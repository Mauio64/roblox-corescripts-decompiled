local BlockContinue = {}
BlockContinue.__index = BlockContinue

local function new(newIndex: number, newColumn: number, finalize: boolean) -- 3 equivalent calls inferred from this helper
	return (setmetatable({ _newIndex = newIndex, _newColumn = newColumn, _finalize = finalize }, BlockContinue))
end

function BlockContinue.none(): nil
	return nil
end

function BlockContinue.atIndex(newIndex: number)
	return new(newIndex, -1, false) -- inferred equivalent call
end

function BlockContinue.atColumn(newColumn: number)
	return new(-1, newColumn, false) -- inferred equivalent call
end

function BlockContinue.finished()
	return new(-1, -1, true) -- inferred equivalent call
end

function BlockContinue:getNewIndex()
	return self._newIndex
end

function BlockContinue:getNewColumn()
	return self._newColumn
end

function BlockContinue:isFinalize()
	return self._finalize
end

return BlockContinue
