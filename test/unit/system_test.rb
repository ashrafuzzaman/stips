require 'test_helper'

class SystemTest < ActionMailer::TestCase
  test "course_registration" do
    @expected.subject = 'System#course_registration'
    @expected.body    = read_fixture('course_registration')
    @expected.date    = Time.now

    assert_equal @expected.encoded, System.create_course_registration(@expected.date).encoded
  end

  test "course_registration_admin" do
    @expected.subject = 'System#course_registration_admin'
    @expected.body    = read_fixture('course_registration_admin')
    @expected.date    = Time.now

    assert_equal @expected.encoded, System.create_course_registration_admin(@expected.date).encoded
  end

end
