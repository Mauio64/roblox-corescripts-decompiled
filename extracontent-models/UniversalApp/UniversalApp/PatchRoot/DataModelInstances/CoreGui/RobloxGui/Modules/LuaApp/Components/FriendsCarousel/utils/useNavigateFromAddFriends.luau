local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ContactImporter = Modules.LuaApp.Components.ContactImporter
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local NavigateDownToAddFriendsPage = require(Modules.LuaApp.Thunks.NavigateDownToAddFriendsPage)
local useContactImporterConfiguration = require(CorePackages.Workspace.Packages.ContactImporter).Utils.useContactImporterConfiguration
local useNavigateToContactImporter = require(ContactImporter.useNavigateToContactImporter)

return function(t1: {[any]: any}) -- line: 11
	-- upvalues: useNavigateToContactImporter (copy), useContactImporterConfiguration (copy), useDispatch (copy), NavigateDownToAddFriendsPage (copy)
	local v9 = useNavigateToContactImporter()
	local v10 = useContactImporterConfiguration(t1)
	local v11 = useDispatch()

	return function() -- line: 19
		-- upvalues: v10 (copy), v9 (copy), v11 (copy), NavigateDownToAddFriendsPage (copy)
		if v10.shouldShowContactImporterModal then
			v9()

			return
		end

		v11(NavigateDownToAddFriendsPage())
	end
end
