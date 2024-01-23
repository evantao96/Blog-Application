describe 'user features' do

  describe '#index' do
    let!(:user) { User.create( email: 'test@test.com', password: 'test123') }
    
    before :each do
      visit '/'
    end

    it 'loads the correct page successfully' do
      expect(status_code).to eql(200)
      expect(page).to have_text('Sign in')
      expect(page).to have_text('See all blog posts')
    end

    it 'does not show Sign out or Create post links if not logged in as user' do
      expect(page).to_not have_text('Sign out')
      expect(page).to_not have_text('Create a new blog post')
    end

    context 'when logged in' do

      def log_in_with(email, password)
        visit '/users/sign_in'
        fill_in 'Email', with: email
        fill_in 'Password', with: password
        click_button 'Log in'
      end

      before :each do 
        log_in_with 'test@test.com', 'test123'
        visit '/'
      end

      it 'loads the correct page successfully' do
        expect(status_code).to eql(200)
        expect(page).to have_text('Sign out')
        expect(page).to have_text('Create a new blog post')
        expect(page).to have_text('See all blog posts')
      end

      it 'only shows Sign out, Create post and See post links for logged in user' do
        expect(page).to have_text('Sign out', count: 1)
        expect(page).to have_text('Create a new blog post', count: 1)
        expect(page).to have_text('See all blog posts', count: 1)
      end

      it 'shows You are already signed in message when attempting to sign in again' do 
        visit '/users/sign_in'
        expect(page).to have_text('You are already signed in.')
      end

    end

  end
end
