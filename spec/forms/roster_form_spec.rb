require "rails_helper"

RSpec.describe RosterForm do
  Given(:admin) { FactoryGirl.build :admin }
  Given!(:pcv)  { FactoryGirl.create :pcv }

  context "invalid rows" do
    Given(:body)  { %{
      email,first_name,last_name,phone,pcv_id,role,location,time_zone
      alice@example.com,Alice,User,+1234,1234,pcv,Erehwon,Bratislava
      bob@example.com,Bob,User,,,pcv,Erehwesle
    } }
    Given(:roster) { Roster.from_csv body, country: pcv.country }
    Given(:form)   { RosterForm.new roster }

    When(:result) { form.validate({}) }

    Then { result == false                            }
    And  { form.rows[0].errors.empty?                 }
    And  { form.rows[1].errors.include? :pcv_id       }
    And  { form.headers.include? "first_name"         }
    And  { form.valid_emails == ["alice@example.com"] }
    And  { form.removed_emails == [pcv.email]         }
  end

  context "invalid headers" do
    Given(:body)  { %{
      country,email,first_name,last_name,phone,pcv_id,role,location,time_zone
      Sometry,alice@example.com,Alice,User,+1234,1234,pcv,Erehwon,Bratislava
    } }
    Given(:roster) { Roster.from_csv body, country: pcv.country }
    Given(:form)   { RosterForm.new roster }

    When(:result) { form.validate({}) }

    Then { result == false               }
    And  { form.errors.include? :headers }
  end

  context "valid" do
    Given(:body)  { %{
      email,first_name,last_name,phone,pcv_id,role,location,time_zone
      alice@example.com,Alice,User,+1234,1234,pcv,Erehwon,Bratislava
    } }
    Given(:roster) { Roster.from_csv body, country: pcv.country }
    Given(:form)   { RosterForm.new roster }

    When(:result) { form.validate({}) }

    Then { result == true                          }
    And  { form.rows.all? { |r| r.errors.empty?  } }
  end
end
