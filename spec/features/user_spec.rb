describe 'devise features' do
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

  describe 'devise/sessions#new' do 
    before :each do 
      visit 'users/sign_in'
    end

    it 'loads the correct page successfully' do
      expect(status_code).to eql(200)
      expect(page).to have_field('Email')
      expect(page).to have_field('Password')
    end

    it 'does not already show signed in user' do
      expect(page).to_not have_text('Sign out')
      expect(page).to_not have_text('Create a new blog post')
    end

    context 'when logged in' do
      before :each do 
        fill_in 'Email', with: 'test@test.com'
        fill_in 'Password', with: 'test123'
        click_button 'Log in'
      end

      it 'loads a page successfully if attempting to sign in again' do 
        visit 'users/sign_in'
        expect(status_code).to eql(200)
      end

      it 'displays You are already signed in if attempting to sign in again' do 
        visit 'users/sign_in'
        expect(page).to have_text('You are already signed in.')
      end
    end
  end

  describe 'devise/sessions#destroy' do 

    context 'when signing out' do
      before :each do 
        visit 'users/sign_in'
        fill_in 'Email', with: 'test@test.com'
        fill_in 'Password', with: 'test123'
        click_button 'Log in'
        click_button 'Sign out'
      end

      it 'loads a page successfully' do 
        expect(status_code).to eql(200)
      end

      it 'loads the correct page' do 
        expect(page).to have_text('Sign in')
        expect(page).to have_text('See all blog posts')
      end

      it 'preserves the user' do 
        expect(User.count).to eql(1)
      end
    end
  end

  describe 'devise/registrations#new' do 
    before :each do 
      visit 'users/sign_up'
    end

    it 'loads the correct page successfully' do
      expect(status_code).to eql(200)
      expect(page).to have_field('Email')
      expect(page).to have_field('Password')
      expect(page).to have_field('Password confirmation')
    end
  end

end
