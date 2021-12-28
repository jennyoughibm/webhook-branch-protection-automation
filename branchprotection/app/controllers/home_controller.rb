class HomeController < ApplicationController
  def show
    welcome = {
      title: 'Webhooks & REST API',
      description: 'Branch protection automation.'
    }
    render json: welcome
  end
end
