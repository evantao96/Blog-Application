describe 'post features' do
  let!(:user1) { User.create(email: 'test@test.com', password: 'test123') }
  let!(:user2) { User.create(email: 'fake@test.com', password: 'test123') }
  let!(:post) { user1.posts.create(title: 'testing', content: '123') }
  let!(:comment) { post.comments.create(content: 'test comment') }

  context 'when logged into an account with comment edit destroy privileges' do 
    before :each do 
      visit 'users/sign_in'
      fill_in 'Email', with: 'test@test.com'
      fill_in 'Password', with: 'test123'
      click_button 'Log in'
    end

    describe 'comments#new' do

      before :each do 
        visit "/posts/#{post.id}/comments/new"
      end

      it 'loads the correct page successfully' do
        expect(status_code).to eql(200)
        expect(page).to have_text('New comment')
      end

      it 'has the correct fields' do 
        expect(page).to have_field('Content')
      end

      it 'creates a new post' do 
        fill_in 'Content', with: '456'
        click_button 'Create Comment'
        expect(Comment.count).to eql(1)
      end

      it 'displays the correct error message' do 
        click_button 'Create Comment'
        expect(page).to have_text('Content can\'t be blank')
      end
    end

    describe 'comments#edit' do 

      before :each do 
        user1.comments << comment
        visit "/posts/#{post.id}/comments/#{comment.id}/edit"
      end

      it 'loads the correct page successfully' do
        expect(status_code).to eql(200)
        expect(page).to have_text('Editing comment')
      end

      it 'edits the comment correctly' do
        fill_in 'Content', with: 'edited content'
        click_button 'Update Comment'
        expect(current_path).to eql("/posts/#{post.id}")
        expect(page).to have_text('Comment was successfully updated.')
      end
    end

    describe 'comments#destroy' do 

      before :each do 
        user1.comments << comment
        visit "/posts/#{post.id}/comments/#{comment.id}"
      end

      it 'deletes the comment' do 
        click_button 'Destroy this comment'
        expect(user1.comments.size).to eql(0)
        expect(post.comments.size).to eql(0)
        expect(current_path).to eql("/posts/#{post.id}")
      end
    end
  end


  context 'when logged into an account without comment edit destroy privileges' do 

    before :each do 
      user1.comments << comment
      visit 'users/sign_in'
      fill_in 'Email', with: 'fake@test.com'
      fill_in 'Password', with: 'test123'
      click_button 'Log in'
    end

    describe 'comments#show' do 

      it 'does not show edit and destroy buttons' do 
        visit "/posts/#{post.id}/comments/#{comment.id}"
        expect(page).not_to have_button('Edit this comment')
        expect(page).not_to have_button('Destroy this comment')
      end
    end


    describe 'comments#edit' do 

      it 'redirects to the posts page' do
        visit "/posts/#{post.id}/comments/#{comment.id}/edit"
        expect(current_path).to eql("/posts")
      end
    end
  end
end
