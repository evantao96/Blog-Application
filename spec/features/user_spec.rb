describe 'user features' do
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
      expect(page).to have_text('Log in')
      expect(page).to have_text('Sign up')
      expect(page).to have_text('Forgot your password')
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

      it 'displays You are already signed in if attempting to sign in again' do 
        visit 'users/sign_in'
        expect(status_code).to eql(200)
        expect(page).to have_text('You are already signed in.')
      end
    end

    it 'says Invalid Email or password when username is incorrect' do 
      fill_in 'Email', with: 'incorrect@test.com'
      fill_in 'Password', with: 'test123'
      click_button 'Log in'
      expect(page).to have_text('Invalid Email or password.')
    end

    it 'says Invalid Email or password when password is incorrect' do 
      fill_in 'Email', with: 'test@test.com'
      fill_in 'Password', with: 'incorrect123'
      click_button 'Log in'
      expect(page).to have_text('Invalid Email or password.')
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

      it 'loads the correct page successfully' do 
        expect(status_code).to eql(200)
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

    it 'loads the correct page successfully' do 
      fill_in 'Email', with: 'foobar@test.com'
      fill_in 'Password', with: 'test123'
      fill_in 'Password confirmation', with: 'test123'
      click_button 'Sign up'
      expect(status_code).to eql(200)
      expect(page).to have_text("Welcome foobar@test.com")
      expect(page).to have_text("Sign out")
      expect(page).to have_text("Create a new blog post")
      expect(page).to have_text("See all blog posts")
    end

    it 'displays Email can\'t be blank message' do 
      fill_in 'Password', with: 'test123'
      fill_in 'Password confirmation', with: 'test123'
      click_button 'Sign up'
      expect(page).to have_text("Email can\'t be blank")  
    end 

    it 'displays Password can\'t be blank message' do 
      fill_in 'Email', with: 'foobar@test.com'
      fill_in 'Password confirmation', with: 'test123'
      click_button 'Sign up'
      expect(page).to have_text("Password can\'t be blank")  
      expect(page).to have_text("Password confirmation doesn\'t match Password")  
    end 

    it 'displays Password confirmation doesn\'t match when password confirmation is blank message' do 
      fill_in 'Email', with: 'foobar@test.com'
      fill_in 'Password', with: 'test123'
      click_button 'Sign up'
      expect(page).to have_text("Password confirmation doesn\'t match Password")  
    end 

    it 'displays Password confirmation doesn\'t match when passwords don\'t match message' do 
      fill_in 'Email', with: 'foobar@test.com'
      fill_in 'Password', with: 'test123'
      fill_in 'Password confirmation', with: 'test321'
      click_button 'Sign up'
      expect(page).to have_text("Password confirmation doesn\'t match Password")  
    end 

    it 'displays Password is too short message' do 
      fill_in 'Email', with: 'foobar@test.com'
      fill_in 'Password', with: 'test'
      fill_in 'Password confirmation', with: 'test'
      click_button 'Sign up'
      expect(page).to have_text("Password is too short")  
    end 

    it 'checks if email address is already taken' do 
      fill_in 'Email', with: 'test@test.com'
      fill_in 'Password', with: 'test123'
      fill_in 'Password confirmation', with: 'test123'
      click_button 'Sign up'
      expect(page).to have_text("Email has already been taken")  
    end 

    context 'when logged in' do
      before :each do 
        visit '/users/sign_in'
        fill_in 'Email', with: 'test@test.com'
        fill_in 'Password', with: 'test123'
        click_button 'Log in'
      end

      it 'displays You are already signed in if attempting to sign up' do 
        visit 'users/sign_up'
        expect(status_code).to eql(200)
        expect(page).to have_text('You are already signed in.')
      end
    end

  end

  describe 'devise/passwords#new' do 
    before :each do 
      visit '/users/sign_in'
      click_link 'Forgot your password?'
    end

    it 'loads the correct page successfully' do
      expect(status_code).to eql(200)
      expect(page).to have_field('Email')
      expect(page).to have_button('Send me reset password instructions')
    end

    it 'redirects to the login page successfully' do
      fill_in 'Email', with: 'test@test.com'
      click_button('Send me reset password instructions')
      expect(status_code).to eql(200)
      expect(page).to have_text("Log in")
    end
  end

end
