local ParentParent = script.Parent.Parent.Parent
local jest = require(ParentParent.Dev.JestGlobals).jest
local React = require(ParentParent.React)
local Signals = require(ParentParent.Signals)

return {
	createMockPeopleService = function(p1) -- line: 10
		-- upvalues: jest (copy), React (copy), Signals (copy)
		return {
			getService = jest.fn(function(p2) -- line: 12
				-- upvalues: jest (copy), React (copy), p1 (copy), Signals (copy)
				if p2 == "PeopleBlockingModalManager" then
					return {
						getModalManager = jest.fn(function(_, _) -- line: 15
							-- upvalues: React (copy)
							return function(p5) -- line: 16
								-- upvalues: React (copy)
								return React.createElement("Frame", {
									[React.Tag] = "data-testid=blockingModalManager"
								}, p5.children)
							end
						end)
					}
				end

				if p2 == "Flags" then
					return {
						GetFFlagAddPeoplePageCardLayout = p1.GetFFlagAddPeoplePageCardLayout,
						GetFFlagPeoplePageLazyRenderCards = p1.GetFFlagPeoplePageLazyRenderCards,
						GetFFlagFixPeoplePageCardTooltip = p1.GetFFlagFixPeoplePageCardTooltip,
						FFlagEnablePeopleListLazyRender = p1.FFlagEnablePeopleListLazyRender,
						GetFFlagPeoplePagePostponeInitialRender = p1.GetFFlagPeoplePagePostponeInitialRender,
						FFlagShowSwitchServerButton = p1.FFlagShowSwitchServerButton
					}
				end

				if p2 == "PeopleListStore" then
					return {
						people = Signals.createSignal({})
					}
				end

				if p2 == "PeopleAnalyticsManager" then
					return {
						trackPeoplePageLayoutChanged = jest.fn()
					}
				end

				return {}
			end)
		}
	end
}
