require 'rails_helper'

RSpec.feature 'Hiring staff are sent to the correct sign in service' do
  scenario 'School is in Cambs' do
    visit new_sessions_path
    choose('Cambridgeshire')
    click_button 'Sign in to Teaching Jobs'

    expect(page).to have_content('Area: Cambridgeshire')
  end

  scenario 'School is in The North East' do
    visit new_sessions_path
    choose('The North East')
    click_button 'Sign in to Teaching Jobs'

    expect(page).to have_content('Area: The North East')
  end

  scenario 'School is in Central Bedfordshire' do
    visit new_sessions_path
    choose('Central Bedfordshire')
    click_button 'Sign in to Teaching Jobs'

    expect(page).to have_content('Area: Central Bedfordshire')
  end

  scenario 'School is in Any other area' do
    visit new_sessions_path
    choose('Any other area')
    click_button 'Sign in to Teaching Jobs'

    expect(page).to have_content('Area: Any other area')
  end
end