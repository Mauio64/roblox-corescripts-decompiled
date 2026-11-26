local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)

local retrievalStatus = UIBlox.App.Loading.Enum.RetrievalStatus
local loadingStateContainer = UIBlox.App.Container.LoadingStateContainer

local extended = Roact.PureComponent:extend("AvatarExperienceLoaded")

require("@luauforge/bundled/dKT")

extended.validateProps = t.strictInterface({
	showLoadingBar = t.boolean,
	[Roact.Children] = t.optional(t.table),
	avatarExperienceLoaded = t.boolean
})

function extended:init()
	function self.emptyRenderFunction(): nil
		return nil
	end
end

function extended:getLoadingStatus()
	if self.props.avatarExperienceLoaded then
		return retrievalStatus.Done
	end

	return retrievalStatus.Fetching
end

function extended:render()
	local v6 = if not self.props.showLoadingBar then self.emptyRenderFunction else nil

	return Roact.createElement(loadingStateContainer, {
		dataStatus = self:getLoadingStatus(),
		renderOnLoaded = function()
			return Roact.oneChild(self.props[Roact.Children])
		end,
		renderOnLoading = v6
	})
end

local function mapStateToProps(p2, p3)
	return {
		avatarExperienceLoaded = p2.AvatarExperience.Common.AvatarExperienceLoaded
	}
end

local v6 = RoactRodux.connect(mapStateToProps, nil)(extended)

return function(p2, p3)
	local v7 = p3 == nil or p3

	return function(p4)
		return Roact.createElement(v6, { showLoadingBar = v7 }, {
			Child = Roact.createElement(p2, p4)
		})
	end
end
