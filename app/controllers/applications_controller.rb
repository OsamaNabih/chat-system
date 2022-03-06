class ApplicationsController < ApplicationController
  before_action :set_application, except: [:index, :create]
  before_action :block_blank_name, only: [:create, :update]

  def index
    #@apps = Application.all
    @apps = Application.connection.select_all("SELECT token, chats_count, created_at, updated_at FROM applications")
    render json: @apps
  end

  def show
    @app = @app.pluck(:token, :chats_count)
    render json: @app
  end

  def create
    @app = Application.new(application_params)
    @app[:token] = SecureRandom.urlsafe_base64
    if @app.save
      render json: {msg: "Application created successfully", token: @app[:token]}, status: :ok
    else
      render json: {msg: "Application creation failed. Please double check the data provided"}, status: :unprocessable_entity
    end
  end

  def update
    if @app.update(article_params)
      render json: {msg: "Application updated successfully"}, status: :ok
    else
      render json: {msg: "Application update failed. Please double check the data provided"}, status: :unprocessable_entity
    end
  end

  def destroy
    @app.destroy
    head :ok
  end

  private
    def set_application
      # Raise record not found exception if the provided token doesn't match any of our records
      @app = Application.find_by_token!(params[:id])
    end

    def application_params
      params.require(:application).permit(:name)
    end

    # Since creation will be delegated to a worker
    # We need to infer the success of the request before assigning it to queue
    def block_blank_name
      if params[:name].to_s.strip.empty?
        render json: {msg: "Name must not be empty"}, status: :unprocessable_entity
      end
    end
end
