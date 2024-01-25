describe 'post features' do
  let!(:user) { User.create(email: 'test@test.com', password: 'test123') }
  let!(:post) { user.posts.create(title: 'testing', content: '123') }

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

  # describe 'posts#edit' do 


  #   before :each do 
  #     visit "/posts/#{post.id}/edit"
  #   end

  #   it 'loads the correct page successfully' do
  #     expect(status_code).to eql(200)
  #     expect(page).to have_text('Editing post')
  #   end

  #   it 'edits the status correctly' do
  #     fill_in 'Title', with: 'edited title'
  #     fill_in 'Content', with: 'edited content'
  #     click_button 'Update Post'
  #     expect(current_path).to eql("/posts/#{post.id}")
  #     expect(page).to have_text('Post was successfully updated.')
  #   end
  # end

  # describe 'posts#destroy' do 
  #   let!(:post) { user.posts.create(title: 'testing', content: '123') }

  #   before :each do 
  #     visit "/posts/#{post.id}"
  #   end

  #   it 'deletes the post' do 
  #     click_button 'Destroy this post'
  #     expect(user.posts.size).to eql(0)
  #     expect(current_path).to eql("/posts")
  #   end
  # end
end
