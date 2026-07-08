local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local React = require(MomentsParent.React)
local MomentsSessionContext = require(Moments.Stores.GetMomentsStore.MomentsSessionContext)
local MomentsHostContext = require(Moments.MomentsHostContext)

require(Moments.Stores.GetMomentsStore.createMomentsStore)

local ExperienceDetailsSheet = require(Moments.ExperienceDetailsSheet).ExperienceDetailsSheet
local ToastOverlay = require(Moments.Components.ToastOverlay)

local function MomentsHostShell(t1: {[any]: any}) -- line: 45
	-- upvalues: React (copy), MomentsSessionContext (copy), MomentsHostContext (copy), ExperienceDetailsSheet (copy), ToastOverlay (copy)
	local v10 = React.useMemo(function() -- line: 46
		-- upvalues: t1 (copy)
		return {
			openProfile = t1.openProfile,
			openOwnMoments = t1.openOwnMoments
		}
	end, {
		t1.openProfile,
		t1.openOwnMoments
	})

	return React.createElement(MomentsSessionContext.MomentsSessionContext.Provider, {
		value = t1.sessionStore
	}, {
		Host = React.createElement(MomentsHostContext.MomentsHostContext.Provider, {
			value = v10
		}, {
			Content = React.createElement(React.Fragment, nil, t1.children, React.createElement(ExperienceDetailsSheet), React.createElement(ToastOverlay))
		})
	})
end

return MomentsHostShell
