local PostLoadFunc = function ( self, controller )
	PlayClip( self, "ReadyAnim", controller )
end

CoD.T10AmmoEquipment = InheritFrom( LUI.UIElement )
CoD.T10AmmoEquipment.new = function ( menu, controller )
	local self = LUI.UIElement.new()

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end

	self:setUseStencil( false )
	self:setClass( CoD.T10AmmoEquipment )
	self.id = "T10AmmoEquipment"
	self.soundSet = "default"
	self:setLeftRight( true, false, 0, 1280 )
	self:setTopBottom( true, false, 0, 720 )
	self.anyChildUsesUpdateState = true

	self.Background1 = LUI.UIImage.new()
	self.Background1:setLeftRight( false, true, -166, 0 )
	self.Background1:setTopBottom( false, true, -73.5, -18.5 )
	self.Background1:setImage( RegisterImage( "ximage_2211b5bf6aa069d" ) )
	self.Background1:setRGB( 0.3, 0.3, 0.3 )
	self:addElement( self.Background1 )

	self.Background2 = LUI.UIImage.new()
	self.Background2:setLeftRight( false, true, -166, 0 )
	self.Background2:setTopBottom( false, true, -73.5, -18.5 )
	self.Background2:setImage( RegisterImage( "ximage_d3879ee3e11ade" ) )
	self.Background2:setAlpha( 0.7 )
	self:addElement( self.Background2 )

	self.Lethal = LUI.UIImage.new()
	self.Lethal:setLeftRight( false, true, -57.5, -20 )
	self.Lethal:setTopBottom( false, true, -63, -25.5 )
	self.Lethal:setImage( RegisterImage( "blacktransparent" ) )
	self.Lethal:setScale( 0.65 )
	self.Lethal:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "currentPrimaryOffhand.primaryOffhand" ), function ( model )
		local primaryOffhand = Engine.GetModelValue( model )

		if primaryOffhand then
			if primaryOffhand == "uie_t7_zm_hud_inv_icnlthl" then
				self.Lethal:setImage( RegisterImage( "ximage_3ccdec4e2b8ba0f" ) )

			elseif primaryOffhand == "uie_t7_zm_hud_inv_widowswine" then
				self.Lethal:setImage( RegisterImage( "ui_icon_weapons_zm_semtex" ) )

			else
				self.Lethal:setImage( RegisterImage( primaryOffhand ) )
			end
		end
	end )
	self:addElement( self.Lethal )

	self.LethalCount = LUI.UIText.new()
	self.LethalCount:setLeftRight( false, true, 0, -32 )
	self.LethalCount:setTopBottom( false, true, -48, -25 )
	self.LethalCount:setText( Engine.Localize( "" ) )
    self.LethalCount:setTTF( "fonts/monospac821_bt_wgl4_1.ttf" )
	self.LethalCount:setScale( 0.5 )
	self.LethalCount:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_RIGHT )
	self.LethalCount:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "currentPrimaryOffhand.primaryOffhandCount" ), function ( model )
		local primaryOffhandCount = Engine.GetModelValue( model )

		if primaryOffhandCount then
			if primaryOffhandCount == 0 then
				self.LethalCount:setText( Engine.Localize( "" ) )
			else
				self.LethalCount:setText( Engine.Localize( primaryOffhandCount ) )
			end
		end
	end )
	self:addElement( self.LethalCount )

	self.Tactical = LUI.UIImage.new()
    self.Tactical:setLeftRight( false, true, -146, -108.5 )
    self.Tactical:setTopBottom( false, true, -63, -25.5 )
	self.Tactical:setImage( RegisterImage( "blacktransparent" ) )
	self.Tactical:setScale( 0.65 )
	self.Tactical:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "currentSecondaryOffhand.secondaryOffhand" ), function ( model )
		local secondaryOffhand = Engine.GetModelValue( model )

		if secondaryOffhand then
			if secondaryOffhand == "hud_cymbal_monkey_bo3" then
				self.Tactical:setImage( RegisterImage( "ximage_e84af69e3c9d724" ) )
			else
				self.Tactical:setImage( RegisterImage( secondaryOffhand ) )
			end
		end
	end )
	self:addElement( self.Tactical )

	self.TacticalCount = LUI.UIText.new()
	self.TacticalCount:setLeftRight( false, true, 0 - 89, -32 - 89 )
	self.TacticalCount:setTopBottom( false, true, -48, -25 )
	self.TacticalCount:setText( Engine.Localize( "" ) )
    self.TacticalCount:setTTF( "fonts/monospac821_bt_wgl4_1.ttf" )
	self.TacticalCount:setScale( 0.5 )
	self.TacticalCount:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_RIGHT )
	self.TacticalCount:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "currentSecondaryOffhand.secondaryOffhandCount" ), function ( model )
		local secondaryOffhandCount = Engine.GetModelValue( model )

		if secondaryOffhandCount then
			if secondaryOffhandCount == 0 then
				self.TacticalCount:setText( Engine.Localize( "" ) )
			else
				self.TacticalCount:setText( Engine.Localize( secondaryOffhandCount ) )
			end
		end
	end )
	self:addElement( self.TacticalCount )

	self.SpecialBG = LUI.UIImage.new()
	self.SpecialBG:setLeftRight( false, true, -111, -56 )
	self.SpecialBG:setTopBottom( false, true, -73.5, -18.5 )
	self.SpecialBG:setImage( RegisterImage( "ximage_89bc9beef04fb63" ) )
	self.SpecialBG:setScale( 1.05 )
	self:addElement( self.SpecialBG )

	self.SpecialIcon = LUI.UIImage.new()
	self.SpecialIcon:setLeftRight( false, true, -111, -56 )
	self.SpecialIcon:setTopBottom( false, true, -73.5, -18.5 )
	self.SpecialIcon:setImage( RegisterImage( "ui_icon_fieldupgrade_zm_aether_shroud" ) )
	self.SpecialIcon:setScale( 0.78 )
	self:addElement( self.SpecialIcon )

	self.SpecialMeterBG = LUI.UIImage.new()
	self.SpecialMeterBG:setLeftRight( false, true, -111, -56 )
	self.SpecialMeterBG:setTopBottom( false, true, -73.5, -18.5 )
	self.SpecialMeterBG:setImage( RegisterImage( "ximage_c800fc9cce96f23" ) )
	self.SpecialMeterBG:setScale( 1.05 )
	self:addElement( self.SpecialMeterBG )

	self.SpecialMeter = LUI.UIImage.new()
	self.SpecialMeter:setLeftRight( false, true, -111, -56 )
	self.SpecialMeter:setTopBottom( false, true, -73.5, -18.5 )
	self.SpecialMeter:setImage( RegisterImage( "ximage_836c48038391c06" ) )
	self.SpecialMeter:setMaterial( LUI.UIImage.GetCachedMaterial( "uie_clock_normal" ) )
	self.SpecialMeter:setShaderVector( 0, 0, 0, 0, 0 )
	self.SpecialMeter:setShaderVector( 1, 0.59, 0, 0, 0 )
	self.SpecialMeter:setShaderVector( 2, 0.49, 0, 0, 0 )
	self.SpecialMeter:setShaderVector( 3, 0, 0, 0, 0 )
	self.SpecialMeter:setRGB( 1, 0.68, 0 )
	self.SpecialMeter:setZRot( 180 )
	self.SpecialMeter:setScale( 1.05 )
	self.SpecialMeter:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "zmhud.swordEnergy" ), function ( model )
		local swordEnergy = Engine.GetModelValue( model )

		if swordEnergy then
			self.SpecialMeter:setShaderVector( 0, AdjustStartEnd( 0, 0.93,
				CoD.GetVectorComponentFromString( swordEnergy, 1 ),
				CoD.GetVectorComponentFromString( swordEnergy, 2 ),
				CoD.GetVectorComponentFromString( swordEnergy, 3 ),
				CoD.GetVectorComponentFromString( swordEnergy, 4 ) ) )
		end
	end )
	self:addElement( self.SpecialMeter )

	self.SpecialMeterReady1 = LUI.UIImage.new()
	self.SpecialMeterReady1:setLeftRight( false, true, -111, -56 )
	self.SpecialMeterReady1:setTopBottom( false, true, -73.5, -18.5 )
	self.SpecialMeterReady1:setImage( RegisterImage( "blacktransparent" ) )
	self.SpecialMeterReady1:setRGB( 1, 0.68, 0 )
	self.SpecialMeterReady1:setScale( 1.05 )
	self.SpecialMeterReady1:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "zmhud.swordEnergy" ), function ( model )
		local swordEnergy = Engine.GetModelValue( model )

		if swordEnergy then
			if swordEnergy >= 1 then
				self.SpecialMeterReady1:setImage( RegisterImage( "ximage_58d2b2f6f49c85" ) )
			else
				self.SpecialMeterReady1:setImage( RegisterImage( "blacktransparent" ) )
			end
		end
	end )
	self:addElement( self.SpecialMeterReady1 )

	self.SpecialMeterReady2 = LUI.UIImage.new()
	self.SpecialMeterReady2:setLeftRight( false, true, -111, -56 )
	self.SpecialMeterReady2:setTopBottom( false, true, -73.5, -18.5 )
	self.SpecialMeterReady2:setImage( RegisterImage( "blacktransparent" ) )
	self.SpecialMeterReady2:setRGB( 1, 1, 0.80 )
	self.SpecialMeterReady2:setZRot( 90 )
	self.SpecialMeterReady2:setScale( 1.05 )
	self.SpecialMeterReady2:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "zmhud.swordEnergy" ), function ( model )
		local swordEnergy = Engine.GetModelValue( model )

		if swordEnergy then
			if swordEnergy >= 1 then
				self.SpecialMeterReady2:setImage( RegisterImage( "ximage_e0683b14f47e4fc" ) )
			else
				self.SpecialMeterReady2:setImage( RegisterImage( "blacktransparent" ) )
			end
		end
	end )
	self:addElement( self.SpecialMeterReady2 )

	self.SpecialCount = LUI.UIText.new()
	self.SpecialCount:setLeftRight( false, true, -111, -56 )
	self.SpecialCount:setTopBottom( false, true, -73.5 + 20 + 14, -18.5 + 20 - 14 )
	self.SpecialCount:setText( Engine.Localize( "0" ) )
	self.SpecialCount:setTTF( "fonts/monospac821_bt_wgl4_1.ttf" )
	self.SpecialCount:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self.SpecialCount:setScale( 0.5 )
	self.SpecialCount:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "zmhud.swordEnergy" ), function ( model )
		local swordEnergy = Engine.GetModelValue( model )

		if swordEnergy then
			if swordEnergy >= 1 then
				self.SpecialCount:setText( Engine.Localize( "1" ) )
			else
				self.SpecialCount:setText( Engine.Localize( "0" ) )
			end
		end
	end )
	self:addElement( self.SpecialCount )

	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 0 )
			end,
			ReadyAnim = function ()
				self:setupElementClipCounter( 1 )

				local ReadyAnimFrame3 = function ( element, event )
					if not event.interrupted then
						element:beginAnimation( "keyframe", 2000, false, false, CoD.TweenType.Linear )
					end
	
					element:setAlpha( 0 )
	
					if event.interrupted then
						self.clipFinished( element, event )
					else
						element:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
					end
				end

				local ReadyAnimFrame2 = function ( element, event )
					if event.interrupted then
						ReadyAnimFrame3( element, event )

						return 
					else
						element:beginAnimation( "keyframe", 4000, false, false, CoD.TweenType.Linear )

						element:setZRot( -270 )

						element:registerEventHandler( "transition_complete_keyframe", ReadyAnimFrame3 )
					end
				end

				local ReadyAnimFrame1 = function ( element, event )
					if event.interrupted then
						ReadyAnimFrame2( element, event )

						return 
					else
						element:beginAnimation( "keyframe", 2000, false, false, CoD.TweenType.Linear )

						element:setAlpha( 1 )

						element:registerEventHandler( "transition_complete_keyframe", ReadyAnimFrame2 )
					end
				end
				
				self.SpecialMeterReady2:completeAnimation()
				self.SpecialMeterReady2:setAlpha( 0 )
				self.SpecialMeterReady2:setZRot( 90 )
				ReadyAnimFrame1( self.SpecialMeterReady2, {} )

				self.nextClip = "ReadyAnim"
			end
		}
	}

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.Background1:close()
		element.Background2:close()
		element.Lethal:close()
		element.LethalCount:close()
		element.Tactical:close()
		element.TacticalCount:close()
		element.SpecialBG:close()
		element.SpecialIcon:close()
		element.SpecialMeterBG:close()
		element.SpecialMeter:close()
		element.SpecialMeterReady1:close()
		element.SpecialMeterReady2:close()
		element.SpecialCount:close()
	end )
	
	if PostLoadFunc then
		PostLoadFunc( self, controller, menu )
	end
	
	return self
end
