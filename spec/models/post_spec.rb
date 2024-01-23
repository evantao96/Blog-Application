describe 'Post' do
  let!(:user) { User.create(email: 'user1@test.com', password: 'user1test') }
  let!(:post) { user.posts.create(title: 'new post title', content: 'testing') }
  let!(:comment) { user.comments.create(content: 'new comment1') }

  describe 'belongs_to user' do

    it 'belongs to user' do
      expect(post.user).to eq(user)
      expect(user.posts).to include(post)
    end

  end

  describe 'has_many comments' do  

    it 'has many comments' do 
      expect { post.comments << comment }.to change(Comment, :count).by 1 
      expect(post.comments).to include(comment)
      expect(comment.post).to eq(post)
    end

  end

  describe 'validations' do

    it 'will not save without a title' do
      expect { Post.create(content: 'testing', user: user) }.to change(Post, :count).by 0
    end

    it 'will not save without content' do
      expect { Post.create(title: 'new post title', user: user) }.to change(Post, :count).by 0
    end

    it 'will not save without a user' do
      expect { Post.create(title: 'new post title', content: 'testing') }.to change(Post, :count).by(0)
    end

  end

end
