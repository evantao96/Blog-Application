describe 'User' do
  let!(:user) { User.create(email: 'user1@test.com', password: 'user1test') }
  let!(:post) { user.posts.create(title: 'new post title', content: 'testing') }
  let!(:comment1) { post.comments.create(content: "first comment") }
  let!(:comment2) { post.comments.create(content: "second comment") }

  describe 'has_many posts' do

    it 'has many posts' do
      expect(user.posts).to include(post)
      expect(post.user).to eq(user)
    end

    it 'deletes associated post' do
      num_posts = user.posts.size * -1
      expect { user.destroy }.to change(Post, :count).by num_posts
    end

  end

  describe 'has_many comments' do

    it 'has many comments' do 
      user.comments << comment1
      user.comments << comment2

      expect(user.comments).to include(comment1)
      expect(user.comments).to include(comment2)
      expect(comment1.user).to eq(user)
      expect(comment2.user).to eq(user)
    end

    it 'deletes associated comment' do
      num_comments = user.comments.size * -1
      expect { user.destroy }.to change(Comment, :count).by num_comments
    end

  end

  describe 'validations' do

    it 'will not save without an email' do
      expect { User.create(password: 'password') }.to change(User, :count).by 0
    end

    it 'will not save without a password' do
      expect { User.create(email: 'evantao96@gmail.com') }.to change(User, :count).by 0
    end

    it 'will not save with a password shorter than 6 characters' do
      expect { User.create(email: 'email@email.com', password: 'pass') }.to change(User, :count).by 0
    end

    it 'will not save with an email without a username' do
      expect { User.create(email: '@email.com', password: 'password') }.to change(User, :count).by 0
    end

    it 'will not save with an email without a domain name' do
      expect { User.create(email: 'email@', password: 'password') }.to change(User, :count).by 0
    end
    
  end

end
