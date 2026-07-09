local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Roact = require(ParentParentParent.Roact)
local UIBlox = require(ParentParentParent.UIBlox)
local LocaleProvider = require(ParentParent.Locale.LocaleProvider)
local StyleProviderWithDefaultTheme = require(ParentParentParent.Style).StyleProviderWithDefaultTheme
local ok, result = pcall(function() -- line: 12
	-- upvalues: UIBlox (copy), ParentParentParent (copy)
	UIBlox.init(require(ParentParentParent.Dev.RobloxAppUIBloxConfig))
end)

if not ok then
	warn("Error initializing UIBlox", result)
end

local SelectionCursorProvider = UIBlox.App.SelectionImage.SelectionCursorProvider
local CursorProvider = UIBlox.App.SelectionCursor.CursorProvider

local function renderWithStyleProvider(p1, p2) -- line: 22
	-- upvalues: Roact (copy), StyleProviderWithDefaultTheme (copy)
	return Roact.createElement(StyleProviderWithDefaultTheme, {
		theme = p1.theme
	}, p2)
end
local function renderWithLocaleProvider(p3) -- line: 28
	-- upvalues: Roact (copy), LocaleProvider (copy)
	return Roact.createElement(LocaleProvider, {
		locale = "en-us"
	}, p3)
end
local function renderWithCursorProvider(p4) -- line: 34
	-- upvalues: Roact (copy), SelectionCursorProvider (copy), CursorProvider (copy)
	return Roact.createElement(SelectionCursorProvider, {}, {
		NewCursorProvider = Roact.createElement(CursorProvider, {}, p4)
	})
end
local function StoryMiddleware(p5) -- line: 40
	-- upvalues: renderWithStyleProvider (copy), renderWithCursorProvider (copy), Roact (copy), LocaleProvider (copy)
	return function(p6) -- line: 41
		-- upvalues: renderWithStyleProvider (copy), renderWithCursorProvider (copy), Roact (copy), p5 (copy), LocaleProvider (copy)
		local v21 = renderWithStyleProvider
		local t1 = {}
		local t2 = {
			CursorProvider = renderWithCursorProvider({
				Child = Roact.createElement(p5, p6)
			})
		}

		t1.LocaleProvider = Roact.createElement(LocaleProvider, {
			locale = "en-us"
		}, t2)

		return v21(p6, t1)
	end
end

return StoryMiddleware
