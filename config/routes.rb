# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  require "sidekiq/web"
  require "sidekiq/cron/web"

  # use_doorkeeper
  scope :api, defaults: { format: :json } do
    resource :user do
      get :login
      post :register
    end
    devise_for :users, only: []
  end

  mount MailPreview => "mail_view" if Rails.env.development?

  devise_scope :user do
    authenticated do
      root to: "questionnaires#show"
    end

    unauthenticated do
      root to: "devise/sessions#new"
    end
  end

  authenticate :user, ->(u) { u.director? } do
    mount Sidekiq::Web => "/sidekiq"
    mount Blazer::Engine, at: "blazer"
  end

  # devise doesnt parse GET /user
  resource :user, only: :show, constraints: ->(req) { req.format == :json }

  resource :questionnaires, path: "questionnaire" do
    get :schools, on: :collection
  end

  resource :rsvp do
    patch :accept, on: :collection
    patch :deny, on: :collection
  end

  resource :bus_list do
    patch :boarded_bus, on: :collection
  end

  resources :events, only: [:index, :show]

  namespace :manage do
    authenticate :user, ->(u) { u.director? } do
      root to: "dashboard#index"
    end
    authenticate :user, ->(u) { u.organizer? } do
      root to: "dashboard#index"
    end
    authenticate :user, ->(u) { u.volunteer? } do
      root to: "checkins#index"
    end
    resources :questionnaires do
      post :datatable, on: :collection
      patch :check_in, on: :member
      patch :update_acc_status, on: :member
      patch :bulk_apply, on: :collection
    end
    resources :events do
    end
    resources :messages do
      get :preview, on: :member
      get :live_preview, on: :collection
      patch :deliver, on: :member
      patch :duplicate, on: :member
      # Message template
      get :template, on: :collection
      get :template_preview, on: :collection
      patch :template_update, on: :collection
      post :template_replace_with_default, on: :collection
    end
    resources :bus_lists do
      post :toggle_bus_captain, on: :member
      patch :send_update_email, on: :member
    end
    resources :schools do
      patch :perform_merge, on: :member
    end
    resources :users do
      post :user_datatable, on: :collection
      post :staff_datatable, on: :collection
      patch :reset_password, on: :member
    end
    resources :agreements
    resources :configs do
      patch :update_only_css_variables, on: :member
      get :enter_theming_editor, on: :collection
      get :exit_theming_editor, on: :collection
    end
    resources :trackable_events
    resources :trackable_tags
    resources :data_exports
  end
end
