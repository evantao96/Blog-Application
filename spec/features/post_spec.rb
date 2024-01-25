describe 'post features' do
  let!(:user1) { User.create(email: 'test@test.com', password: 'test123') }
  let!(:user2) { User.create(email: 'fake@test.com', password: 'test123') }

  context 'when logged into an account with post edit destroy privileges' do 
    before :each do 
      visit 'users/sign_in'
      fill_in 'Email', with: 'test@test.com'
      fill_in 'Password', with: 'test123'
      click_button 'Log in'
    end

    describe 'posts#new' do

      before :each do 
        visit '/posts/new'
      end

      it 'loads the correct page successfully' do
        expect(status_code).to eql(200)
        expect(page).to have_text('New post')
      end

      it 'has the correct fields' do 
        expect(page).to have_field('Title')
        expect(page).to have_field('Content')
      end

      it 'creates a new post' do 
        fill_in 'Title', with: 'testing'
        fill_in 'Content', with: '123'
        click_button 'Create Post'
        expect(Post.count).to eql(1)
      end

      it 'displays the correct error message' do 
        click_button 'Create Post'
        expect(current_path).to eql('/posts')
        expect(page).to have_text('Title can\'t be blank')
        expect(page).to have_text('Content can\'t be blank')
      end
    end

    describe 'posts#edit' do 
      let!(:post) { user1.posts.create(title: 'testing', content: '123') }

      before :each do 
        visit "/posts/#{post.id}/edit"
      end

      it 'loads the correct page successfully' do
        expect(status_code).to eql(200)
        expect(page).to have_text('Editing post')
      end

      it 'edits the post correctly' do
        fill_in 'Title', with: 'edited title'
        fill_in 'Content', with: 'edited content'
        click_button 'Update Post'
        expect(current_path).to eql("/posts/#{post.id}")
        expect(page).to have_text('Post was successfully updated.')
      end
    end

    describe 'posts#destroy' do 
      let!(:post) { user1.posts.create(title: 'testing', content: '123') }

      before :each do 
        visit "/posts/#{post.id}"
      end

      it 'deletes the post' do 
        click_button 'Destroy this post'
        expect(user1.posts.size).to eql(0)
        expect(current_path).to eql("/posts")
      end
    end
  end

  context 'when logged into an account without post edit destroy privileges' do 
    let!(:post) { user1.posts.create(title: 'testing', content: '123') }

    before :each do 
      visit 'users/sign_in'
      fill_in 'Email', with: 'fake@test.com'
      fill_in 'Password', with: 'test123'
      click_button 'Log in'
    end

    describe 'posts#show' do 

      it 'does not show edit and destroy buttons' do 
        visit "/posts/#{post.id}"
        expect(page).not_to have_button('Edit this post')
        expect(page).not_to have_button('Destroy this post')
      end
    end

    describe 'posts#edit' do 

      it 'redirects to the posts page' do
        visit "/posts/#{post.id}/edit"
        expect(current_path).to eql('/posts')
      end
    end

  end
end
