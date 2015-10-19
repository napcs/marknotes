require 'test_helper'

class NoteTest < ActiveSupport::TestCase

  test "can't create note without title" do
    note = Note.new
    note.save
    assert note.errors[:title].include? "is too short (minimum is 3 characters)"
  end

  test "can't create note without body" do
    note = Note.new
    note.save
    assert note.errors[:body].include? "can't be blank"
  end

  test "only find visible notes" do
    deleted_note = Note.create(title: "Test", body: "Testing 123")
    deleted_note.update_attributes(deleted: true)
    assert !Note.visible.include?(deleted_note)
  end

  test "search title and content for keyword" do
    Note.create title: "First note", body: "abcde"
    Note.create title: "second note", body: "123abc"
    Note.create title: "abc note", body: "this is a note"

    notes = Note.find_all_by_keyword("abc")

    # should get three notes
    assert_equal 3, notes.length

    # sanity check the last one.
    assert_equal "abc note", notes.last.title
  end

  test "tag list works" do
    note = Note.create! title: "abc note", tag_list: "homework, school", body: "this is a note"
    assert_equal 2, note.tag_list.count
  end

  test "notes tagged with items can be found through tag" do
    Note.create title: "abc note", tag_list: "homework", body: "this is a note"
    assert_equal "abc note", Note.tagged_with("homework").first.title
  end
end
