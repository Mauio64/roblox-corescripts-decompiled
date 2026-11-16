local TextService = game:GetService("TextService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/TextSize/Foundation")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/TextSize/Signals")

local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local function calculateTextSizeOffset()
	local function fn()
		local font = Font.fromEnum(Enum.Font.BuilderSans)

		local success, result = pcall(function()
			return TextService:GetTextSizeOffsetAsync(0, font)
		end)

		if success then
			return result or 0
		end

		warn(result)
		return 0
	end

	local thread = coroutine.create(fn)
	return (function(p2, p3, ...)
		if not p3 then
			return nil
		end

		if coroutine.status(p2) == "dead" then
			return ...
		end

		return nil
	end)(thread, coroutine.resume(thread)) or 0
end

local function createTextSizeStore()
	local createSignal = Signals.createSignal
	local v5

	if foundationFontFaceMigration then
		v5 = Foundation.Utility.getTextSizeOffset() or 0
	else
		local function fn()
			local font = Font.fromEnum(Enum.Font.BuilderSans)

			local success, result = pcall(function()
				return TextService:GetTextSizeOffsetAsync(0, font)
			end)

			if success then
				return result or 0
			end

			warn(result)
			return 0
		end

		local thread = coroutine.create(fn)
		v5 = (function(p2, p3, ...)
			if not p3 then
				return nil
			end

			if coroutine.status(p2) == "dead" then
				return ...
			end

			return nil
		end)(thread, coroutine.resume(thread)) or 0
	end

	local signal, v6 = createSignal(v5)

	local preferredTextSizeChangedConnection = UserGameSettings:GetPropertyChangedSignal("PreferredTextSize"):Connect(function()
		local v8

		if foundationFontFaceMigration then
			v8 = Foundation.Utility.getTextSizeOffset() or 0
		else
			local function fn()
				local font = Font.fromEnum(Enum.Font.BuilderSans)

				local success, result = pcall(function()
					return TextService:GetTextSizeOffsetAsync(0, font)
				end)

				if success then
					return result or 0
				end

				warn(result)
				return 0
			end

			local thread = coroutine.create(fn)
			v8 = (function(p2, p3, ...)
				if not p3 then
					return nil
				end

				if coroutine.status(p2) == "dead" then
					return ...
				end

				return nil
			end)(thread, coroutine.resume(thread)) or 0
		end

		v6(v8)
	end)

	return {
		getTextSizeOffset = signal,
		cleanup = function()
			if preferredTextSizeChangedConnection then
				preferredTextSizeChangedConnection:Disconnect()
				preferredTextSizeChangedConnection = nil
			end
		end
	}
end

return createTextSizeStore
