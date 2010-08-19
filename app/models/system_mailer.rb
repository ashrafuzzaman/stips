class SystemMailer < ActionMailer::Base
  
  def course_registration_email(course_user)
    subject    "Confirmation email for course registration for #{course_user.title}"
    recipients course_user.user.email
    #from       ''
    sent_on    Time.now
    
    body({:course => course_user.course, :user => course_user.user})
  end

  def course_registration_admin_email(course_user)
    subject    "Confirmation notification email for course registration for #{course_user.title}"
    recipients 'ruben.brunsveld@stips.se'
    #from       ''
    sent_on    Time.now
    
    body({:course => course_user.course, :user => course_user.user})
  end

end
