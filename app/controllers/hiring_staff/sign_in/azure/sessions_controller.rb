class HiringStaff::SignIn::Azure::SessionsController < HiringStaff::BaseController
  skip_before_action :check_session, only: %i[create new failure]
  skip_before_action :verify_authenticity_token, only: %i[create new]

  def new
    # Defined by Azure AD strategy: https://github.com/AzureAD/omniauth-azure-activedirectory#usage
    redirect_to '/auth/azureactivedirectory'
  end

  def create
    permissions = TeacherVacancyAuthorisation::Permissions.new
    permissions.authorise(identifier)

    if permissions.school_urn.present?
      session.update(session_id: oid)
      session.update(urn: permissions.school_urn)
      redirect_to school_path
    else
      redirect_to root_path, notice: I18n.t('errors.sign_in.unauthorised')
    end
  end

  def failure
    Rollbar.log('error', 'Sign in provider returned a failure')
    render html: I18n.t('errors.sign_in.failure')
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end

  def oid
    auth_hash['extra']['raw_info']['id_token_claims']['oid']
  end

  def identifier
    auth_hash['info']['name']
  end
end
