describe 'session features' do
  let!(:user) { User.create( email: 'test@test.com', password: 'test123') }

  describe 'welcome#index' do
      
    before :each do
      visit '/'
    end

    it 'loads the correct page successfully' do
      expect(status_code).to eql(200)
      expect(page).to have_text('Sign in')
      expect(page).to have_text('See all blog posts')
    end

    context 'when logged in' do

      before :each do 
        visit '/users/sign_in'
        fill_in 'Email', with: 'test@test.com'
        fill_in 'Password', with: 'test123'
        click_button 'Log in'
        visit '/'
      end

      it 'loads the correct page successfully' do
        expect(status_code).to eql(200)
        expect(page).to have_text('Sign out')
        expect(page).to have_text('Create a new blog post')
        expect(page).to have_text('See all blog posts')
      end

    end
  end
end