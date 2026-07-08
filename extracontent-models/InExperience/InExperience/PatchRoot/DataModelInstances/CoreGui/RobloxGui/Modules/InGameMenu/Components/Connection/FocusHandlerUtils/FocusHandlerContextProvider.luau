local GuiService = game:GetService("GuiService")
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.InGameMenuDependencies).Roact
local FocusHandlerContext = require(script.Parent.FocusHandlerContext)
local v5 = Roact.PureComponent:extend("FocusHandlerContextProvider")

function v5.init(p1) -- line: 17
	p1.state = {
		candidateHandlerId = nil,
		currentHandlerId = nil
	}
	p1.previousSelections = {}
end
function v5.requestFocusForHandlerId(p2, p3) -- line: 25
	p2:setState(function(p4) -- line: 26
		-- upvalues: p3 (copy)
		if p4.currentHandlerId == nil then
			return {
				currentHandlerId = p3
			}
		end

		if p3 ~= p4.currentHandlerId then
			return {
				candidateHandlerId = p3
			}
		end

		return nil
	end)
end
function v5.blurCurrentFocusHandler(p5, p6, p7) -- line: 41
	-- upvalues: GuiService (copy), Roact (copy)
	p5:setState(function(p8) -- line: 42
		-- upvalues: p6 (copy), p7 (copy), GuiService (copy), p5 (copy), Roact (copy)
		if p8.currentHandlerId == p6 then
			local SelectedCoreObject = nil

			if not p7 then
				SelectedCoreObject = GuiService.SelectedCoreObject
			end

			p5.previousSelections[p6] = SelectedCoreObject

			if p8.candidateHandlerId ~= nil then
				return {
					currentHandlerId = p8.candidateHandlerId,
					candidateHandlerId = Roact.None
				}
			end

			return {
				currentHandlerId = Roact.None
			}
		end

		return nil
	end)
end
function v5.forgetLastSelectionForHandlerId(p9, p10) -- line: 67
	p9.previousSelections[p10] = nil
end
function v5.render(p11) -- line: 71
	-- upvalues: Roact (copy), FocusHandlerContext (copy)
	return Roact.createElement(FocusHandlerContext.Provider, {
		value = {
			currentHandlerId = p11.state.currentHandlerId,
			candidateHandlerId = p11.state.candidateHandlerId,
			previousSelections = p11.previousSelections,
			requestFocusForHandlerId = function(p12) -- line: 77
				-- upvalues: p11 (copy)
				p11:requestFocusForHandlerId(p12)
			end,
			forgetLastSelectionForHandlerId = function(p13) -- line: 80
				-- upvalues: p11 (copy)
				p11:forgetLastSelectionForHandlerId(p13)
			end,
			blurCurrentFocusHandler = function(p14, p15) -- line: 83
				-- upvalues: p11 (copy)
				p11:blurCurrentFocusHandler(p14, p15)
			end
		}
	}, p11.props[Roact.Children])
end

return v5
