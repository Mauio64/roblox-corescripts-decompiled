local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local ExperienceGuidelinesExplainedModal = require(script.Parent.ExperienceGuidelinesExplainedModal)

local function ExperienceGuidelinesExplained(t1: {[any]: any}) -- line: 18
	-- upvalues: useDispatch (copy), React (copy), ExperienceGuidelinesExplainedModal (copy)
	local v7 = useDispatch()

	return React.createElement(ExperienceGuidelinesExplainedModal, {
		universeId = t1.universeId,
		hideCloseButton = t1.hideCloseButton,
		closeModal = if not t1.closeCentralOverlayThunk then nil else function() -- line: 24
			-- upvalues: v7 (copy), t1 (copy)
			v7(t1.closeCentralOverlayThunk())
		end
	})
end

return ExperienceGuidelinesExplained
