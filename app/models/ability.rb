# frozen_string_literal: true

##
# CanCanCan abilities for authorisation
class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user || User.new # guest user (not logged in)

    meth = @user.role.blank? ? :guest! : :"#{@user.role}!"
    send(meth) if respond_to?(meth, true) # e.g. admin!
  end

  def needs_permission?
    return true if @user.role == 'editor'
    false
  end

  protected

  def guest!
    can :show, Banner.published
    can :show, Collection.published
    can :show, Gallery.published
    can :show, Page.published
  end

  def user!
    can :show, Banner.published
    can :show, Collection.published
    can :show, Gallery.published
    can :show, Page.published
  end

  def editor!
    can :access, :rails_admin
    can :dashboard
    can :show, :entity
    can :read, [Banner, BrowseEntry, Collection, DataProvider, Feed, Gallery,
                HeroImage, Link, MediaObject, Page, Topic, User]
    can :create, [BrowseEntry, Gallery]
    can :update, [DataProvider, HeroImage, MediaObject]
    can :update, BrowseEntry.with_permissions_by(@user)
    can :publish, BrowseEntry.with_permissions_by(@user)
    can :unpublish, BrowseEntry.with_permissions_by(@user)
    can :update, Gallery.with_permissions_by(@user)
    can :publish, Gallery.with_permissions_by(@user)
    can :unpublish, Gallery.with_permissions_by(@user)
    can :update, Page::Landing.with_permissions_by(@user)
  end

  def admin!
    can :access, :rails_admin
    can :dashboard
    can :show, :entity
    can :manage, [Banner, BrowseEntry, Collection, DataProvider, Feed, Gallery,
                  HeroImage, Link, MediaObject, Page, Topic, User]
  end
end
