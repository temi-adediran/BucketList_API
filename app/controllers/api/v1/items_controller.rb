class Api::V1::ItemsController < ApplicationController
  before_action :authenticate_request!
  before_action :set_bucket_list, only: [:set_item, :index, :create, :show,
   :update, :destroy]
  before_action :set_item, only: [:show, :update, :destroy]
 

  def index
    items = @bucket_list.items

    if items.empty?
      render json: { message: "No item created yet." }, status: 200
    else
      render json: items, status: 200
    end
  end

  def create
    @item = @bucket_list.items.new(item_params)

    if @item.save
      render json: @item, status: :created
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @item, status: 200
  end

  def update
    if @item.update(item_params)
      render json: @item, status: 200
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @item.destroy
    render json: { message: "Item deleted successfully!" }, status: 200
  end

  private

  def set_item
    @item = @bucket_list.items.find_by(id: params[:id])
    
    unless @item
      render json: { error: "Unauthorized access" }, status: 404
    end
  end

  def set_bucket_list
    @bucket_list = current_user.bucket_lists.find(params[:bucketlist_id])

    unless @bucket_list
      render json: { error: "Unauthorized access" }, status: 404
    end
  end

  def item_params
    params.permit(:name)
  end
end
