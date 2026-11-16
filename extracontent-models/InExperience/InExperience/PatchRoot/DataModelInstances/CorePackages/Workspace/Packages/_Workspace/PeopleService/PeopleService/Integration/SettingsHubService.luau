local parent = script.Parent.Parent.Parent

local Signals = require(parent.Signals)

local v = nil
local signal, setShowMenuButtonsContainer = Signals.createSignal(false)

local function createSettingsHubService()
	return {
		register = function(p)
			v = p
		end,
		hubRef = function()
			return v and v.HubRef or nil
		end,
		pageRef = function()
			return v and v.Page or nil
		end,
		showMenuButtonsContainer = signal,
		setShowMenuButtonsContainer = setShowMenuButtonsContainer
	}
end

return createSettingsHubService()
