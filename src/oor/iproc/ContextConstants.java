/**
 * 
 */
package oor.iproc;

/**
 * @author nikhillo
 *
 */
public interface ContextConstants {
	public static final String __REV__ = "$Rev$ $Date$";
	/** Generic **/
	public static final String SRC_IMG = "source";
	public static final String TGT_IMG = "target";
	public static final String SRC_FEATURES = "srcFeatures";
	public static final String TGT_FEATURES = "tgtFeatures";

	/** Subtract background (SB) **/
	public static final String SB_RADIUS = "radius";
	public static final String SB_CREATEBG = "createBackground";
	public static final String SB_LIGHTBG = "lightBackground";
	public static final String SB_USEPARA = "useParaboloid";
	public static final String SB_PRESMOOTH = "doPresmooth";
	public static final String SB_CORRCORN = "correctCorners";
	
	/** Morphology (MP) **/
	public static final String MP_TYPE = "type";
	public static final String MP_RADIUS = "radius";
	public static final String MP_CMD = "command";
	
	/** MOPS features (MOF) **/
	public static final String MOF_FDSZ = "fdSize";
	public static final String MOF_INITSIG = "initialSigma";
	public static final String MOF_MAXOCT = "maxOctaveSize";
	public static final String MOF_MINOCT = "minOctaveSize";
	public static final String MOF_STEPS = "steps";
	
	/** SIFT features (SIF) **/
	public static final String SIF_FDBINS = "fdBins";
	public static final String SIF_FDSZ = "fdSize";
	public static final String SIF_INITSIG = "initialSigma";
	public static final String SIF_MAXOCT = "maxOctaveSize";
	public static final String SIF_MINOCT = "minOctaveSize";
	public static final String SIF_STEPS = "steps";
	
	/** Feature matcher (FM) **/
	public static final String FM_ROD = "rod";
	public static final String FM_ALGORITHM = "algorithm";
	public static final String FM_BRUTEFTRS = "bruteForce";
	
	/** Consensus matcher (CM) **/
	public static final String CM_MODEL = "model";
	public static final String CM_CANDIDATES = "candidates";
	public static final String CM_MAXEPS = "maxEpsilon";
	public static final String CM_MINIR = "minnlierRatio";
	public static final String CM_INLIERS = "inliers";
	
	/** Point Match Marker (PMM) **/
	public static final String PMM_COLOR = "color";
	public static final String PMM_MATCHES = "matches";
	
}
