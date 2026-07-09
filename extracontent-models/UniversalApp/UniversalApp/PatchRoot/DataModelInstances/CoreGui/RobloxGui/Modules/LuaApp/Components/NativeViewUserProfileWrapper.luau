local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local NativeViewProfileWrapper = require(Modules.LuaApp.Components.NativeViewProfileWrapper)
local UrlBuilder = require(Modules.LuaApp.Http.UrlBuilder)
local v6 = Roact.PureComponent:extend("NativeViewUserProfileWrapper")

function v6.render(p1) -- line: 11
	-- upvalues: UrlBuilder (copy), Roact (copy), NativeViewProfileWrapper (copy)
	local isVisible = p1.props.isVisible
	local DisplayOrder = p1.props.DisplayOrder
	local userId = p1.props.userId
	local onClose = p1.props.onClose
	local v12 = UrlBuilder.user.profile({
		userId = userId
	})

	return Roact.createElement(NativeViewProfileWrapper, {
		isVisible = isVisible,
		DisplayOrder = DisplayOrder,
		url = v12,
		onClose = onClose
	})
end

return v6
