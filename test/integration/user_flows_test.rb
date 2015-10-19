require 'test_helper'

class UserFlowsTest < ActionDispatch::IntegrationTest

  # create a user we can monkey with
  setup do
    @user = User.create! email: "test@example.com", password: "abcd1234", password_confirmation: "abcd1234"
  end

  test "login, create new note, and share it" do

    visit '/'
    click_on "Log In"
    fill_in 'Email', :with => 'test@example.com'
    fill_in 'Password', :with => 'abcd1234'
    click_button 'Log in'

    # on dashboard
    page.has_content? 'Recent Notes'
    click_on "New Note"

    # note page
    page.has_content? 'New Note'

    fill_in "Title", :with => 'This is the title'
    fill_in "Tags", :with => 'homework, school'
    fill_in "Body", :with => '# Hello World'
    click_on "Create Note"
    page.has_content? 'Note was successfully created.'

    click_on "Share"
    page.has_content? 'Note shared at'

    # get share url - share url is a#share_url
    find_by_id("share_url").click

    page.has_content? '<h1>Hello World</h1>'

    # ensure footer exists
    page.has_content? 'Create your own'

    visit "/"
    click_on "Dashboard"
    click_on "This is the title"
    click_on "Unshare"
    page.has_content? "Note was successfully unshared"

  end

  test "login and trash some notes" do
    @user.notes.create! title: "Note 1", body: "Note one body"
    @user.notes.create! title: "Note 2", body: "Note two body"

    visit '/'
    click_on "Log In"
    fill_in 'Email', :with => 'test@example.com'
    fill_in 'Password', :with => 'abcd1234'
    click_button 'Log in'

    click_on "Note 1"
    click_on "Delete"
    page.has_no_content? "Note 1"

    click_on "Trash"
    page.has_content? "Note 1"

    click_on "Dashboard"

    click_on "Note 2"
    click_on "Delete"
    page.has_no_content? "Note 2"

    click_on "Trash"
    page.has_content? "Note 1"
    page.has_content? "Note 2"

    click_on "Empty Trash"
    page.has_content? "The trash was emptied"
    page.has_content? "The trash is empty"
  end
end
