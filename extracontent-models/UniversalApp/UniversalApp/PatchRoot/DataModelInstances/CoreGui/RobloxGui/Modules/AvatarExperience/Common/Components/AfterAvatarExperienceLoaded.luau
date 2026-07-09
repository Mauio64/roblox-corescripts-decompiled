local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local RetrievalStatus = UIBlox.App.Loading.Enum.RetrievalStatus
local LoadingStateContainer = UIBlox.App.Container.LoadingStateContainer
local v9 = Roact.PureComponent:extend("AvatarExperienceLoaded")
local Modules = CoreGui.RobloxGui.Modules

require(Modules.AvatarExperience.Common.AvatarExperienceState)
v9.validateProps = t.strictInterface({
	showLoadingBar = t.boolean,
	[Roact.Children] = t.optional(t.table),
	avatarExperienceLoaded = t.boolean
})

function v9.init(p1) -- line: 38
	function p1.emptyRenderFunction() -- line: 39
		return nil
	end
end
function v9.getLoadingStatus(p2) -- line: 44
	-- upvalues: RetrievalStatus (copy)
	if not p2.props.avatarExperienceLoaded then
		return RetrievalStatus.Fetching
	end

	return RetrievalStatus.Done
end
function v9.render(p3) -- line: 52
	-- upvalues: Roact (copy), LoadingStateContainer (copy)
	local emptyRenderFunction = nil

	if not p3.props.showLoadingBar then
		emptyRenderFunction = p3.emptyRenderFunction
	end

	return Roact.createElement(LoadingStateContainer, {
		dataStatus = p3:getLoadingStatus(),
		renderOnLoaded = function() -- line: 61
			-- upvalues: Roact (copy), p3 (copy)
			return Roact.oneChild(p3.props[Roact.Children])
		end,
		renderOnLoading = emptyRenderFunction
	})
end

local function mapStateToProps(p4, _) -- line: 68
	return {
		avatarExperienceLoaded = p4.AvatarExperience.Common.AvatarExperienceLoaded
	}
end

local u12 = RoactRodux.connect(mapStateToProps, nil)(v9)

return function(p6, b1: boolean?) -- line: 76
	-- upvalues: Roact (copy), u12 (ref)
	if b1 == nil then
		b1 = true
	end

	return function(p7) -- line: 81
		-- upvalues: Roact (copy), u12 (ref), b1 (ref), p6 (copy)
		return Roact.createElement(u12, {
			showLoadingBar = b1
		}, {
			Child = Roact.createElement(p6, p7)
		})
	end
end
