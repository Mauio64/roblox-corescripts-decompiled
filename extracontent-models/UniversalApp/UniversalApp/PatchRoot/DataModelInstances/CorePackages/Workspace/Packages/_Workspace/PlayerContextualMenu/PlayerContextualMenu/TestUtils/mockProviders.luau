local ParentParent = script.Parent.Parent.Parent
local React = require(ParentParent.React)
local RoactRodux = require(ParentParent.RoactRodux)
local Rodux = require(ParentParent.Rodux)
local Style = require(ParentParent.Style)
local Localization = require(ParentParent.Localization)
local Signal = require(ParentParent.Dev.AppCommonLib).Signal
local RoactNavigation = require(ParentParent.Dev.RoactNavigation)

local function staticReducer(p1) -- line: 11
	return p1
end

return function(p2, t1: {[any]: any}?) -- line: 15
	-- upvalues: React (copy), RoactRodux (copy), Rodux (copy), staticReducer (copy), RoactNavigation (copy), Style (copy), Localization (copy), Signal (copy)
	return React.createElement(RoactRodux.StoreProvider, {
		store = Rodux.Store.new(staticReducer, {}, { Rodux.thunkMiddleware })
	}, {
		Navigation = React.createElement(RoactNavigation.Provider, {
			value = t1 and t1.navigation or {
				navigate = function() -- line: 21
				end
			}
		}, {
			UiModeStyle = React.createElement(Style.UiModeStyleProvider, {
				style = {
					themeName = "Dark",
					fontName = "Gotham"
				}
			}, {
				DesignTokenProvider = React.createElement(Style.DesignTokenProvider, {
					tokenMappers = {}
				}, {
					localization = React.createElement(Localization.LocalizationProvider, {
						localization = {
							Format = function(_, p4, _) -- line: 35
								return p4
							end,
							changed = Signal.new()
						}
					}, {
						child = p2
					})
				})
			})
		})
	})
end
