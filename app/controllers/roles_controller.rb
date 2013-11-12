class RolesController < ApplicationController

	def index
		@roles = Role.all
		@permisisons = Permission.all
	end

	def update
		@role = Role.find params[:id]
		@permisison = Permission.find params[:permission_id]
		if params[:change] == 'true'
			@role.permissions << @permisison
		else
			@role.permissions.find(params[:permission_id]).delete
		end
		render json: {status: 200}
	end

end