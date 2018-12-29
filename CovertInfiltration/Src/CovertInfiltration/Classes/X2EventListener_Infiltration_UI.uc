//---------------------------------------------------------------------------------------
//  AUTHOR:  Xymanek
//  PURPOSE: Listeners for various UI events (mostly CHL hooks)
//---------------------------------------------------------------------------------------
//  WOTCStrategyOverhaul Team
//---------------------------------------------------------------------------------------

class X2EventListener_Infiltration_UI extends X2EventListener;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateGeoscapeListeners());
	Templates.AddItem(CreateAvengerHUDListeners());

	return Templates;
}

////////////////
/// Geoscape ///
////////////////

static function CHEventListenerTemplate CreateGeoscapeListeners()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'Infiltration_UI_Geoscape');
	Template.AddCHEvent('Geoscape_ResInfoButtonVisible', GeoscapeResistanceButtonVisible, ELD_Immediate); // Relies on CHL #365, will be avaliable in v1.17
	Template.AddCHEvent('GeoscapeFlightModeUpdate', GeoscapeFlightModeUpdate, ELD_Immediate); // Relies on CHL #358, will be avaliable in v1.17
	Template.RegisterInStrategy = true;

	return Template;
}

static protected function EventListenerReturn GeoscapeResistanceButtonVisible(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComLWTuple Tuple;
	local XComGameState_FacilityXCom FacilityState;

	Tuple = XComLWTuple(EventData);
	if (Tuple == none || Tuple.Id != 'Geoscape_ResInfoButtonVisible') return ELR_NoInterrupt;

	FacilityState = `XCOMHQ.GetFacilityByName('ResistanceRing');
	Tuple.Data[0].b = FacilityState != none && !Tuple.Data[1].b;
	
	return ELR_NoInterrupt;
}

static protected function EventListenerReturn GeoscapeFlightModeUpdate(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local UIStrategyMap StrategyMap;
	local bool bInFlight;

	StrategyMap = UIStrategyMap(EventSource);
	bInFlight = StrategyMap.IsInFlightMode();

	StrategyMap.StrategyMapHUD.GetChildByName('CovertActionButton').SetVisible(!bInFlight);
	StrategyMap.StrategyMapHUD.GetChildByName('CovertActionButtonNew').SetVisible(!bInFlight);

	return ELR_NoInterrupt;
}

///////////////////
/// Avenger HUD ///
///////////////////

static function CHEventListenerTemplate CreateAvengerHUDListeners()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'Infiltration_UI_AvengerHUD');
	Template.AddCHEvent('UIAvengerShortcuts_ShowCQResistanceOrders', ShortcutsResistanceButtonVisible, ELD_Immediate); // Relies on CHL #368, will be avaliable in v1.17
	Template.RegisterInStrategy = true;

	return Template;
}

static protected function EventListenerReturn ShortcutsResistanceButtonVisible(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComLWTuple Tuple;

	Tuple = XComLWTuple(EventData);
	if (Tuple == none || Tuple.Id != 'UIAvengerShortcuts_ShowCQResistanceOrders') return ELR_NoInterrupt;

	// NEVAH!!!
	Tuple.Data[0].b = false;
	
	return ELR_NoInterrupt;
}