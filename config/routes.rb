Rails.application.routes.draw do
  resources :firmwares, only: [:create, :index, :new] do
    get '/delete' => 'firmwares#delete'
    get '/download' => 'download#download'
  end
end
