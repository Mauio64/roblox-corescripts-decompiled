local rules = script.Parent.rules

local ExecutableDefinitionsRule = require(rules.ExecutableDefinitionsRule)
local executableDefinitionsRule = ExecutableDefinitionsRule.ExecutableDefinitionsRule
local UniqueOperationNamesRule = require(rules.UniqueOperationNamesRule)
local uniqueOperationNamesRule = UniqueOperationNamesRule.UniqueOperationNamesRule

local LoneAnonymousOperationRule = require(rules.LoneAnonymousOperationRule)
local loneAnonymousOperationRule = LoneAnonymousOperationRule.LoneAnonymousOperationRule

local SingleFieldSubscriptionsRule = require(rules.SingleFieldSubscriptionsRule)
local singleFieldSubscriptionsRule = SingleFieldSubscriptionsRule.SingleFieldSubscriptionsRule
local KnownTypeNamesRule = require(rules.KnownTypeNamesRule)
local knownTypeNamesRule = KnownTypeNamesRule.KnownTypeNamesRule

local FragmentsOnCompositeTypesRule = require(rules.FragmentsOnCompositeTypesRule)
local fragmentsOnCompositeTypesRule = FragmentsOnCompositeTypesRule.FragmentsOnCompositeTypesRule

local VariablesAreInputTypesRule = require(rules.VariablesAreInputTypesRule)
local variablesAreInputTypesRule = VariablesAreInputTypesRule.VariablesAreInputTypesRule
local ScalarLeafsRule = require(rules.ScalarLeafsRule)
local scalarLeafsRule = ScalarLeafsRule.ScalarLeafsRule
local FieldsOnCorrectTypeRule = require(rules.FieldsOnCorrectTypeRule)
local fieldsOnCorrectTypeRule = FieldsOnCorrectTypeRule.FieldsOnCorrectTypeRule
local UniqueFragmentNamesRule = require(rules.UniqueFragmentNamesRule)
local uniqueFragmentNamesRule = UniqueFragmentNamesRule.UniqueFragmentNamesRule
local KnownFragmentNamesRule = require(rules.KnownFragmentNamesRule)
local knownFragmentNamesRule = KnownFragmentNamesRule.KnownFragmentNamesRule
local NoUnusedFragmentsRule = require(rules.NoUnusedFragmentsRule)
local noUnusedFragmentsRule = NoUnusedFragmentsRule.NoUnusedFragmentsRule

local PossibleFragmentSpreadsRule = require(rules.PossibleFragmentSpreadsRule)
local possibleFragmentSpreadsRule = PossibleFragmentSpreadsRule.PossibleFragmentSpreadsRule
local NoFragmentCyclesRule = require(rules.NoFragmentCyclesRule)
local noFragmentCyclesRule = NoFragmentCyclesRule.NoFragmentCyclesRule
local UniqueVariableNamesRule = require(rules.UniqueVariableNamesRule)
local uniqueVariableNamesRule = UniqueVariableNamesRule.UniqueVariableNamesRule
local NoUndefinedVariablesRule = require(rules.NoUndefinedVariablesRule)
local noUndefinedVariablesRule = NoUndefinedVariablesRule.NoUndefinedVariablesRule
local NoUnusedVariablesRule = require(rules.NoUnusedVariablesRule)
local noUnusedVariablesRule = NoUnusedVariablesRule.NoUnusedVariablesRule
local KnownDirectivesRule = require(rules.KnownDirectivesRule)
local knownDirectivesRule = KnownDirectivesRule.KnownDirectivesRule

local UniqueDirectivesPerLocationRule = require(rules.UniqueDirectivesPerLocationRule)
local uniqueDirectivesPerLocationRule = UniqueDirectivesPerLocationRule.UniqueDirectivesPerLocationRule
local KnownArgumentNamesRule = require(rules.KnownArgumentNamesRule)
local knownArgumentNamesRule = KnownArgumentNamesRule.KnownArgumentNamesRule

local KnownArgumentNamesOnDirectivesRule = KnownArgumentNamesRule.KnownArgumentNamesOnDirectivesRule
local UniqueArgumentNamesRule = require(rules.UniqueArgumentNamesRule)
local uniqueArgumentNamesRule = UniqueArgumentNamesRule.UniqueArgumentNamesRule
local ValuesOfCorrectTypeRule = require(rules.ValuesOfCorrectTypeRule)
local valuesOfCorrectTypeRule = ValuesOfCorrectTypeRule.ValuesOfCorrectTypeRule
local ProvidedRequiredArgumentsRule = require(rules.ProvidedRequiredArgumentsRule)

local providedRequiredArgumentsRule = ProvidedRequiredArgumentsRule.ProvidedRequiredArgumentsRule

local ProvidedRequiredArgumentsOnDirectivesRule = ProvidedRequiredArgumentsRule.ProvidedRequiredArgumentsOnDirectivesRule

local VariablesInAllowedPositionRule = require(rules.VariablesInAllowedPositionRule)
local variablesInAllowedPositionRule = VariablesInAllowedPositionRule.VariablesInAllowedPositionRule

local OverlappingFieldsCanBeMergedRule = require(rules.OverlappingFieldsCanBeMergedRule)
local overlappingFieldsCanBeMergedRule = OverlappingFieldsCanBeMergedRule.OverlappingFieldsCanBeMergedRule
local UniqueInputFieldNamesRule = require(rules.UniqueInputFieldNamesRule)
local uniqueInputFieldNamesRule = UniqueInputFieldNamesRule.UniqueInputFieldNamesRule
local LoneSchemaDefinitionRule = require(rules.LoneSchemaDefinitionRule)
local loneSchemaDefinitionRule = LoneSchemaDefinitionRule.LoneSchemaDefinitionRule
local UniqueOperationTypesRule = require(rules.UniqueOperationTypesRule)
local uniqueOperationTypesRule = UniqueOperationTypesRule.UniqueOperationTypesRule
local UniqueTypeNamesRule = require(rules.UniqueTypeNamesRule)
local uniqueTypeNamesRule = UniqueTypeNamesRule.UniqueTypeNamesRule
local UniqueEnumValueNamesRule = require(rules.UniqueEnumValueNamesRule)
local uniqueEnumValueNamesRule = UniqueEnumValueNamesRule.UniqueEnumValueNamesRule

local UniqueFieldDefinitionNamesRule = require(rules.UniqueFieldDefinitionNamesRule)
local uniqueFieldDefinitionNamesRule = UniqueFieldDefinitionNamesRule.UniqueFieldDefinitionNamesRule
local UniqueDirectiveNamesRule = require(rules.UniqueDirectiveNamesRule)
local uniqueDirectiveNamesRule = UniqueDirectiveNamesRule.UniqueDirectiveNamesRule

local PossibleTypeExtensionsRule = require(rules.PossibleTypeExtensionsRule)
return {
	specifiedRules = {
		executableDefinitionsRule,
		uniqueOperationNamesRule,
		loneAnonymousOperationRule,
		singleFieldSubscriptionsRule,
		knownTypeNamesRule,
		fragmentsOnCompositeTypesRule,
		variablesAreInputTypesRule,
		scalarLeafsRule,
		fieldsOnCorrectTypeRule,
		uniqueFragmentNamesRule,
		knownFragmentNamesRule,
		noUnusedFragmentsRule,
		possibleFragmentSpreadsRule,
		noFragmentCyclesRule,
		uniqueVariableNamesRule,
		noUndefinedVariablesRule,
		noUnusedVariablesRule,
		knownDirectivesRule,
		uniqueDirectivesPerLocationRule,
		knownArgumentNamesRule,
		uniqueArgumentNamesRule,
		valuesOfCorrectTypeRule,
		providedRequiredArgumentsRule,
		variablesInAllowedPositionRule,
		overlappingFieldsCanBeMergedRule,
		uniqueInputFieldNamesRule
	},
	specifiedSDLRules = {
		loneSchemaDefinitionRule,
		uniqueOperationTypesRule,
		uniqueTypeNamesRule,
		uniqueEnumValueNamesRule,
		uniqueFieldDefinitionNamesRule,
		uniqueDirectiveNamesRule,
		knownTypeNamesRule,
		knownDirectivesRule,
		uniqueDirectivesPerLocationRule,
		PossibleTypeExtensionsRule.PossibleTypeExtensionsRule,
		KnownArgumentNamesOnDirectivesRule,
		uniqueArgumentNamesRule,
		uniqueInputFieldNamesRule,
		ProvidedRequiredArgumentsOnDirectivesRule
	}
}
