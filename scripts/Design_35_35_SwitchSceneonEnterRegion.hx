package scripts;

import com.stencyl.graphics.G;
import com.stencyl.graphics.BitmapWrapper;

import com.stencyl.behavior.Script;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.ActorScript;
import com.stencyl.behavior.SceneScript;
import com.stencyl.behavior.TimedTask;

import com.stencyl.models.Actor;
import com.stencyl.models.GameModel;
import com.stencyl.models.actor.Animation;
import com.stencyl.models.actor.ActorType;
import com.stencyl.models.actor.Collision;
import com.stencyl.models.actor.Group;
import com.stencyl.models.Scene;
import com.stencyl.models.Sound;
import com.stencyl.models.Region;
import com.stencyl.models.Font;
import com.stencyl.models.Joystick;

import com.stencyl.Engine;
import com.stencyl.Input;
import com.stencyl.Key;
import com.stencyl.utils.Utils;

import openfl.ui.Mouse;
import openfl.display.Graphics;
import openfl.display.BlendMode;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.events.TouchEvent;
import openfl.net.URLLoader;

import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2Fixture;
import box2D.dynamics.joints.B2Joint;
import box2D.collision.shapes.B2Shape;

import motion.Actuate;
import motion.easing.Back;
import motion.easing.Cubic;
import motion.easing.Elastic;
import motion.easing.Expo;
import motion.easing.Linear;
import motion.easing.Quad;
import motion.easing.Quart;
import motion.easing.Quint;
import motion.easing.Sine;

import com.stencyl.graphics.shaders.BasicShader;
import com.stencyl.graphics.shaders.GrayscaleShader;
import com.stencyl.graphics.shaders.SepiaShader;
import com.stencyl.graphics.shaders.InvertShader;
import com.stencyl.graphics.shaders.GrainShader;
import com.stencyl.graphics.shaders.ExternalShader;
import com.stencyl.graphics.shaders.InlineShader;
import com.stencyl.graphics.shaders.BlurShader;
import com.stencyl.graphics.shaders.SharpenShader;
import com.stencyl.graphics.shaders.ScanlineShader;
import com.stencyl.graphics.shaders.CSBShader;
import com.stencyl.graphics.shaders.HueShader;
import com.stencyl.graphics.shaders.TintShader;
import com.stencyl.graphics.shaders.BloomShader;



class Design_35_35_SwitchSceneonEnterRegion extends SceneScript
{
	public var _Region:Region;
	public var _NextScene:Scene;
	public var _Actor:Actor;
	public var _InRegion:Bool;
	public var _OnlySwitchOnKeyPress:Bool;
	public var _SwitchControl:String;
	public var _OutTime:Float;
	public var _InTime:Float;
	public var _TransitionStyle:String;
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_SwitchScene():Void
	{
		if(((hasValue(_NextScene)) && !(isTransitioning())))
		{
			if((_TransitionStyle == "Fade"))
			{
				switchScene(_NextScene.getID(), createFadeOut(_OutTime), createFadeIn(_InTime));
			}
			else if((_TransitionStyle == "Blinds"))
			{
				switchScene(_NextScene.getID(), createBlindsOut(_OutTime), createBlindsIn(_InTime));
			}
			else if((_TransitionStyle == "Bubbles"))
			{
				switchScene(_NextScene.getID(), createBubblesOut(_OutTime), createBubblesIn(_InTime));
			}
			else if((_TransitionStyle == "Spotlight"))
			{
				switchScene(_NextScene.getID(), createCircleOut(_OutTime), createCircleIn(_InTime));
			}
			else if((_TransitionStyle == "Blur"))
			{
				switchScene(_NextScene.getID(), createPixelizeOut(_OutTime), createPixelizeIn(_InTime));
			}
			else if((_TransitionStyle == "Box"))
			{
				switchScene(_NextScene.getID(), createRectangleOut(_OutTime), createRectangleIn(_InTime));
			}
			else if((_TransitionStyle == "Crossfade"))
			{
				switchScene(_NextScene.getID(), null, createCrossfadeTransition(_OutTime));
			}
			else if((_TransitionStyle == "Slide Up"))
			{
				switchScene(_NextScene.getID(), null, createSlideUpTransition(_OutTime));
			}
			else if((_TransitionStyle == "Slide Down"))
			{
				switchScene(_NextScene.getID(), null, createSlideDownTransition(_OutTime));
			}
			else if((_TransitionStyle == "Slide Left"))
			{
				switchScene(_NextScene.getID(), null, createSlideLeftTransition(_OutTime));
			}
			else if((_TransitionStyle == "Slide Right"))
			{
				switchScene(_NextScene.getID(), null, createSlideRightTransition(_OutTime));
			}
		}
	}
	
	
	public function new(dummy:Int, dummy2:Engine)
	{
		super();
		nameMap.set("Region", "_Region");
		nameMap.set("Next Scene", "_NextScene");
		nameMap.set("Actor", "_Actor");
		nameMap.set("In Region", "_InRegion");
		_InRegion = false;
		nameMap.set("Only Switch On Key Press", "_OnlySwitchOnKeyPress");
		_OnlySwitchOnKeyPress = false;
		nameMap.set("Switch Control", "_SwitchControl");
		nameMap.set("Out Time", "_OutTime");
		_OutTime = 0.5;
		nameMap.set("In Time", "_InTime");
		_InTime = 0.5;
		nameMap.set("Transition Style", "_TransitionStyle");
		_TransitionStyle = "";
		
	}
	
	override public function init()
	{
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				_InRegion = false;
				propertyChanged("_InRegion", _InRegion);
				if((((hasValue(_Actor)) && _Actor.isAlive()) && (((hasValue(_Region)) && (hasValue(_NextScene))) && !(isTransitioning()))))
				{
					if(isInRegion(_Actor, _Region))
					{
						if(_OnlySwitchOnKeyPress)
						{
							_InRegion = true;
							propertyChanged("_InRegion", _InRegion);
						}
						else
						{
							_customEvent_SwitchScene();
						}
					}
				}
			}
		});
		
		/* =========================== Keyboard =========================== */
		addKeyStateListener(_SwitchControl, function(pressed:Bool, released:Bool, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && pressed)
			{
				if(_InRegion)
				{
					_customEvent_SwitchScene();
				}
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}