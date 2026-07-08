local ParentParent = script.Parent.Parent.Parent
local SharedFlags = require(ParentParent.SharedFlags)
local Signals = require(ParentParent.Signals)
local FFlagIEMFocusNavPeoplePageToButtons = SharedFlags.FFlagIEMFocusNavPeoplePageToButtons
local u5 = nil
local v6, v7 = Signals.createSignal(false)

local function createSettingsHubService() -- line: 14
	-- upvalues: u5 (ref), FFlagIEMFocusNavPeoplePageToButtons (copy), v6 (copy), v7 (copy)
	return {
		register = function(p1) -- line: 17
			-- upvalues: u5 (ref)
			u5 = p1
		end,
		hubRef = function() -- line: 22
			-- upvalues: u5 (ref)
			return u5 and u5.HubRef or nil
		end,
		pageRef = if not FFlagIEMFocusNavPeoplePageToButtons then nil else function() -- line: 26
			-- upvalues: u5 (ref)
			return u5 and u5.Page or nil
		end,
		showMenuButtonsContainer = v6,
		setShowMenuButtonsContainer = v7
	}
end

return (createSettingsHubService())
