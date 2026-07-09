local WhatsNew = script:FindFirstAncestor("WhatsNew")
local WhatsNewParent = WhatsNew.Parent
local ScopeActions = require(WhatsNew.registry.ScopeActions)
local jest = require(WhatsNewParent.Dev.JestGlobals).jest

local function createMockScopeActions() -- line: 19
	-- upvalues: jest (copy), ScopeActions (copy)
	local t1 = {
		OpenExperienceMenu = jest.fn(),
		CloseExperienceMenu = jest.fn(),
		OpenSettings = jest.fn(),
		CloseSettings = jest.fn()
	}

	return {
		scopeActions = ScopeActions.createScopeActions(t1),
		spies = t1
	}
end

return createMockScopeActions
