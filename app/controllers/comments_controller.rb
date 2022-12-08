# frozen_string_literal: true

# This is the controller for the Comments resource
class CommentsController < ApplicationController
  def create
    #  Recall the id of the parent article is "known" by the nested routes for Comments,
    #  so params provides us with the parent article
    @article = Article.find(params[:article_id])
    @comment = @article.comments.create(whitelist_comment_params)
    redirect_to article_path(@article)
  end

  # def edit
  #   #  Recall the id of the parent article is "known" by the nested routes for Comments,
  #   #  so params provides us with the parent article

  #   @article = Article.find(params[:article_id])
  #   @comment = @article.comments.find(params[:id])

  # end

  def destroy
    #  Recall the id of the parent article is "known" by the nested routes for Comments,
    #  so params provides us with the parent article
    @article = Article.find(params[:article_id])
    @comment = @article.comments.find(params[:id])
    @comment.destroy
    redirect_to article_path(@article)
  end

  private

  def whitelist_comment_params
    params.require(:comment).permit(:commenter, :content)
  end
end
