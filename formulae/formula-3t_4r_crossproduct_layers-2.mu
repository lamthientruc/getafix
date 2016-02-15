/*************************************************************************************************/
/********************                 DESIGN FOR 3 THREADS            ****************************/
/*************************************************************************************************/
#timer go;
/**
 * Layer 1: To quickly learn PC
 *   + Compute 4 rounds forward (only keeps PC)
 *   + Compute 4 rounds backward (only keeps PC and intersection with 4 forward rounds)
 * Layer 2: To quickly learn Globals
 *   + Compute 4 rounds forward (keeps PC and (Global for each round))
 *   + Compute 4 rounds backward (keeps PC and (Global for each round))
 * Layer 3: To quickly learn Globals
 *   + Compute 4 rounds forward (keeps PC and Global for all rounds)
 *   + Compute 4 rounds backward (keeps PC and Global for all rounds)
 * Layer 4: Compute normally
 */


/*************************************************************************************************/
/*************************************************************************************************/
/*************************************************************************************************/
/******                                                                                    *******/
/******                               Reachability Algorithm                               *******/
/******                                                                                    *******/
/*************************************************************************************************/
/*************************************************************************************************/
/*************************************************************************************************/


mu bool Init_Reach(
 PrCount s_pc,      // Program counter
 Local   s_CL,      // local variable
 Global  s_G        // global variable
)
 s_pc    <  s_CL,
 s_CL    <  s_G
(
  false

  // initial conf

  | initPC(s_pc)    // simply mean init PC

  // forward propagation on internal transitions
  |  ( exists
           PrCount t_pc,
           Local   t_CL,
           Global  t_G.
           (   Init_Reach( t_pc, t_CL, t_G )
               // &(t_G.v1=0 | ( t_G.v1=1 & t_CL.v0=1 ) )
               &( ( programInt1(0, t_pc, s_pc, t_CL, s_CL, t_G, s_G )    // Init module
                    & CopyVariables_ProgramInt( 2, t_pc, t_CL, s_CL, t_G, s_G )
                  )
                  | programInt3(0, t_pc, s_pc, t_CL, s_CL, t_G, s_G )      // Init module
                )
           )
     )

  | ( exists PrCount t_pc.
           (     Init_Reach( t_pc, s_CL, s_G )
               // &(s_G.v1=0 | ( s_G.v1=1 & s_CL.v0=1 ) )
               & programInt2(0, t_pc, s_pc, s_CL, s_G )                // Transitions that only use control flow
           )
      )

);
#size Init_Reach;     //? Show the size of formula
#timer;


// ###   #  #  ###   ###
//  #    ## #   #     #
//  #    ## #   #     #
//  #    # ##   #     #
//  #    # ##   #     #
// ###   #  #  ###    #



bool GlobalInit(Global CG)           // Call Init on Global (shared) variable
( exists
         Module  s_mod,
         PrCount s_pc,
         Local   s_CL.
              (   Init_Reach( s_pc, s_CL, CG )
                & Target_Init(s_pc )
              )
);

// ###   #  #  ###   ###    ##         ###   ###    ##   #  #   ##   ###   ###   ###    ##   #  #
//  #    ## #   #    #  #  #  #         #    #  #  #  #  ## #  #  #   #     #     #    #  #  ## #
//  #    ## #   #    #  #  #  #         #    #  #  #  #  ## #   #     #     #     #    #  #  ## #
//  #    # ##   #    ###   ####  ####   #    ###   ####  # ##    #    #     #     #    #  #  # ##
//  #    # ##   #    # #   #  #         #    # #   #  #  # ##  #  #   #     #     #    #  #  # ##
// ###   #  #   #    #  #  #  #         #    #  #  #  #  #  #   ##   ###    #    ###    ##   #  #

bool programInt1_1(        // For module1
 PrCount cp,
 PrCount dp,
 Local   L,
 Local   dL,
 Global  G,
 Global  dG
)
 cp  ~+ dp,
 cp  <  L,
 L   ~+ dL,
 L   <  G,
 G   ~+ dG
(
  programInt1(1, cp, dp, L, dL, G, dG)
);
#size programInt1_1;
#timer;

bool programInt1_2(        // For module2
 PrCount cp,
 PrCount dp,
 Local   L,
 Local   dL,
 Global  G,
 Global  dG
)
 cp  ~+ dp,
 cp  <  L,
 L   ~+ dL,
 L   <  G,
 G   ~+ dG
(
  programInt1(2, cp, dp, L, dL, G, dG)
);
#size programInt1_2;
#timer;

bool programInt1_3(        // For module3
 PrCount cp,
 PrCount dp,
 Local   L,
 Local   dL,
 Global  G,
 Global  dG
)
 cp  ~+ dp,
 cp  <  L,
 L   ~+ dL,
 L   <  G,
 G   ~+ dG
(
  programInt1(3, cp, dp, L, dL, G, dG)
);
#size programInt1_3;
#timer;

bool programInt2_1(        // For module1
 PrCount cp,
 PrCount dp,
 Local   L,
 Global  G
)
 cp  ~+ dp,
 cp  <  L,
 L  <  G
(
  programInt2(1, cp, dp, L, G)
);
#size programInt2_1;
#timer;

bool programInt2_2(        // For module2
 PrCount cp,
 PrCount dp,
 Local   L,
 Global  G
)
 cp  ~+ dp,
 cp  <  L,
 L  <  G
(
  programInt2(2, cp, dp, L, G)
);
#size programInt2_2;
#timer;

bool programInt2_3(        // For module3
 PrCount cp,
 PrCount dp,
 Local   L,
 Global  G
)
 cp  ~+ dp,
 cp  <  L,
 L  <  G
(
  programInt2(3, cp, dp, L, G)
);
#size programInt2_3;
#timer;

bool CopyVariables_ProgramInt_1(
 PrCount p,
 Local   cL,
 Local   dL,
 Global  cG,
 Global  dG
)
 p  <  cL,
 cL  ~+ dL,
 cL  <  cG,
 cG  ~+ dG
(
  CopyVariables_ProgramInt(1, p, cL, dL, cG, dG)
);
#size CopyVariables_ProgramInt_1;
#timer;

bool CopyVariables_ProgramInt_2(
 PrCount p,
 Local   cL,
 Local   dL,
 Global  cG,
 Global  dG
)
 p  <  cL,
 cL  ~+ dL,
 cL  <  cG,
 cG  ~+ dG
(
  CopyVariables_ProgramInt(2, p, cL, dL, cG, dG)
);
#size CopyVariables_ProgramInt_2;
#timer;

bool CopyVariables_ProgramInt_3(
 PrCount p,
 Local   cL,
 Local   dL,
 Global  cG,
 Global  dG
)
 p  <  cL,
 cL  ~+ dL,
 cL  <  cG,
 cG  ~+ dG
(
  CopyVariables_ProgramInt(3, p, cL, dL, cG, dG)
);
#size CopyVariables_ProgramInt_3;
#timer;


bool FakeOrderingLocalGlobal(
 PrCount    s_pc1,                  // Program counter
 Local      t_CL1,
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      t_CL2,                  // Local variable
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      t_CL3,                  // Local variable
 Local      s_CL3,                  // Local variable
 Global     t_G,                    // Global variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    ~+  t_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    ~+  t_CL2,
 s_CL2    <  s_pc3,
 s_CL3    ~+  t_CL3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G,
 s_G      ~+  t_G
(true
);


 //                                                           #
 // #         #     #   #   ######  #####                    ##
 // #         #     #   #   #       #    #                    #
 // #        ###     # #    #       #    #                    #
 // #        # #      #     ####    #####                     #
 // #       #####     #     #       #  #                      #
 // #       #   #     #     #       #   #                     #
 // #####  ##   ##    #     ######  #    #                    #

// ####    ###   #   #  #   #  ####            #
// #   #  #   #  #   #  #   #   #  #          # #
// #   #  #   #  #   #  ##  #   #  #         #   #
// ####   #   #  #   #  # # #   #  #         #   #
// # #    #   #  #   #  #  ##   #  #         #   #
// #  #   #   #  #   #  #   #   #  #          # #
// #   #   ###    ###   #   #  ####            #

// Forward abstraction

// ###   #  #  ###   ####   ##   ###          #
//  #    #  #  #  #  #     #  #  #  #        ##
//  #    ####  #  #  ###   #  #  #  #         #
//  #    #  #  ###   #     ####  #  #         #
//  #    #  #  # #   #     #  #  #  #         #
//  #    #  #  #  #  ####  #  #  ###         ###

mu bool Thread1_0_Forward_AbsLG(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                      // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
( false

  // initial configuration (init)
  |  (
           initPC(s_pc1)              // Initial PC
         & initPC(s_pc2)              // Initial PC
         & initPC(s_pc3)              // Initial PC
         & GlobalInit(s_G)
     )

//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
         true
      & (exists                  // There exists an internal state that
           PrCount t_pc1,
           Local   t_CL1,
           Global t_G.
           (    (   Thread1_0_Forward_AbsLG( t_pc1, t_CL1, s_pc2, s_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  (
                    programInt1_1(t_pc1,s_pc1,t_CL1,s_CL1,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_1(t_pc1,t_CL1,s_CL1,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(1, t_pc1, s_pc1, t_CL1, s_CL1, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (

          true
       & (exists PrCount t_pc1.
             (     Thread1_0_Forward_AbsLG( t_pc1, s_CL1, s_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_1(t_pc1,s_pc1,s_CL1,s_G)    // Control flow statement
             )
         )
    )

);
#size Thread1_0_Forward_AbsLG;
#timer;


 // #####  #   #  ####   #####    #    ####          ###
 //   #    #   #  #   #  #       # #    #  #        #   #
 //   #    #   #  #   #  #      #   #   #  #            #
 //   #    #####  ####   ####   #   #   #  #          ##
 //   #    #   #  # #    #      #####   #  #         #
 //   #    #   #  #  #   #      #   #   #  #        #
 //   #    #   #  #   #  #####  #   #  ####         #####

mu bool Thread2_0_Forward_AbsLG(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable

 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
( false

  // initial configuration (init)
  |  (  (exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3,
          Global  t_G.
          (
                 Thread1_0_Forward_AbsLG( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G )
              &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )
              &  t_G.v1 = 0
          )
        )
        &  ContextSwitch_1(s_pc1)
     )


//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc2,
           Local   t_CL2,
           Global  t_G.
           (    (   Thread2_0_Forward_AbsLG( s_pc1, s_CL1, t_pc2, t_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_2(t_pc2,s_pc2,t_CL2,s_CL2,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_2(t_pc2,t_CL2,s_CL2,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(2, t_pc2, s_pc2, t_CL2, s_CL2, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc2.
             (     Thread2_0_Forward_AbsLG( s_pc1, s_CL1, t_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_2(t_pc2,s_pc2,s_CL2,s_G)    // Control flow statement
             )
         )
    )

);
#size Thread2_0_Forward_AbsLG;
#timer;


// ###   #  #  ###   ####   ##   ###         ####
//  #    #  #  #  #  #     #  #  #  #           #
//  #    ####  #  #  ###   #  #  #  #         ##
//  #    #  #  ###   #     ####  #  #           #
//  #    #  #  # #   #     #  #  #  #        #  #
//  #    #  #  #  #  ####  #  #  ###          ##

mu bool Thread3_0_Forward_AbsLG(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable

 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
( false

  // initial configuration (init)
  |  (
        (exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3,
          Global  t_G.
          (
                 Thread2_0_Forward_AbsLG( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G )
              &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )
              &  t_G.v1 = 0
          )
        )
        &  ContextSwitch_2(s_pc2)
     )


//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc3,
           Local   t_CL3,
           Global  t_G.
           (    (   Thread3_0_Forward_AbsLG( s_pc1, s_CL1, s_pc2, s_CL2, t_pc3, t_CL3, t_G )
                )
               &(
                  ( programInt1_3(t_pc3,s_pc3,t_CL3,s_CL3,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_3(t_pc3,t_CL3,s_CL3,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(3, t_pc3, s_pc3, t_CL3, s_CL3, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc3.
             (     Thread3_0_Forward_AbsLG( s_pc1, s_CL1, s_pc2, s_CL2,t_pc3, s_CL3, s_G )
                 & programInt2_3(t_pc3,s_pc3,s_CL3,s_G)    // Control flow statement
             )
         )
    )

);
#size Thread3_0_Forward_AbsLG;
#timer;


// ####    ###   #   #  #   #  ####                   #
// #   #  #   #  #   #  #   #   #  #                 ##
// #   #  #   #  #   #  ##  #   #  #                # #
// ####   #   #  #   #  # # #   #  #                  #
// # #    #   #  #   #  #  ##   #  #                  #
// #  #   #   #  #   #  #   #   #  #                  #
// #   #   ###    ###   #   #  ####                 #####

// FORWARD ABSTRACTION


// ###   #  #  ###   ####   ##   ###          #
//  #    #  #  #  #  #     #  #  #  #        ##
//  #    ####  #  #  ###   #  #  #  #         #
//  #    #  #  ###   #     ####  #  #         #
//  #    #  #  # #   #     #  #  #  #         #
//  #    #  #  #  #  ####  #  #  ###         ###

mu bool Thread1_1_Forward_AbsLG(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
( false

  // initial configuration (init)
  |  (
        (exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3,
          Global  t_G.
          (
                 Thread3_0_Forward_AbsLG( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G )
              &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )
              &  t_G.v1 = 0
          )
        )
        &  ContextSwitch_3(s_pc3)
     )

//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
         true
      & (exists                  // There exists an internal state that
           PrCount t_pc1,
           Local   t_CL1,
           Global t_G.
           (    (   Thread1_1_Forward_AbsLG( t_pc1, t_CL1, s_pc2, s_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_1(t_pc1,s_pc1,t_CL1,s_CL1,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_1(t_pc1,t_CL1,s_CL1,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(1, t_pc1, s_pc1, t_CL1, s_CL1, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc1.
             (     Thread1_1_Forward_AbsLG( t_pc1, s_CL1, s_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_1(t_pc1,s_pc1,s_CL1,s_G)    // Control flow statement
             )
         )
    )

);
#size Thread1_1_Forward_AbsLG;
#timer;

 // #####  #   #  ####   #####    #    ####          ###
 //   #    #   #  #   #  #       # #    #  #        #   #
 //   #    #   #  #   #  #      #   #   #  #            #
 //   #    #####  ####   ####   #   #   #  #          ##
 //   #    #   #  # #    #      #####   #  #         #
 //   #    #   #  #  #   #      #   #   #  #        #
 //   #    #   #  #   #  #####  #   #  ####         #####

mu bool Thread2_1_Forward_AbsLG(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
( false

  // initial configuration (init)
  |  (
        (exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3,
          Global  t_G.
          (
                 Thread1_1_Forward_AbsLG( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G )
              &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )
              &  t_G.v1 = 0
          )
        )
        &  ContextSwitch_1(s_pc1)
     )

//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc2,
           Local   t_CL2,
           Global  t_G.
           (    (
                    Thread2_1_Forward_AbsLG( s_pc1, s_CL1, t_pc2, t_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_2(t_pc2,s_pc2,t_CL2,s_CL2,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_2(t_pc2,t_CL2,s_CL2,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(2, t_pc2, s_pc2, t_CL2, s_CL2, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc2.
             (
                  Thread2_1_Forward_AbsLG( s_pc1, s_CL1, t_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_2(t_pc2,s_pc2,s_CL2,s_G)    // Control flow statement
             )
         )
    )

);
#size Thread2_1_Forward_AbsLG;
#timer;

// ###   #  #  ###   ####   ##   ###         ####
//  #    #  #  #  #  #     #  #  #  #           #
//  #    ####  #  #  ###   #  #  #  #         ##
//  #    #  #  ###   #     ####  #  #           #
//  #    #  #  # #   #     #  #  #  #        #  #
//  #    #  #  #  #  ####  #  #  ###          ##

mu bool Thread3_1_Forward_AbsLG(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                      // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
( false
  // initial configuration (init)
  |  (
        (exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3,
          Global  t_G.
          (
                 Thread2_1_Forward_AbsLG( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G )
              &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )
              &  t_G.v1 = 0
          )
        )
        &  ContextSwitch_2(s_pc2)
     )




//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc3,
           Local   t_CL3,
           Global  t_G.
           (    (   Thread3_1_Forward_AbsLG( s_pc1, s_CL1, s_pc2, s_CL2, t_pc3, t_CL3, t_G )
                )
               &(
                  ( programInt1_3(t_pc3,s_pc3,t_CL3,s_CL3,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_3(t_pc3,t_CL3,s_CL3,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(3, t_pc3, s_pc3, t_CL3, s_CL3, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc3.
             (     Thread3_1_Forward_AbsLG( s_pc1, s_CL1, s_pc2, s_CL2,t_pc3, s_CL3, s_G )
                 & programInt2_3(t_pc3,s_pc3,s_CL3,s_G)    // Control flow statement
             )
         )
    )

);
#size Thread3_1_Forward_AbsLG;
#timer;



// ####    ###   #   #  #   #  ####           ###
// #   #  #   #  #   #  #   #   #  #         #   #
// #   #  #   #  #   #  ##  #   #  #             #
// ####   #   #  #   #  # # #   #  #           ##
// # #    #   #  #   #  #  ##   #  #          #
// #  #   #   #  #   #  #   #   #  #         #
// #   #   ###    ###   #   #  ####          #####

// FORWARD ABSTRACTION


// ###   #  #  ###   ####   ##   ###          #
//  #    #  #  #  #  #     #  #  #  #        ##
//  #    ####  #  #  ###   #  #  #  #         #
//  #    #  #  ###   #     ####  #  #         #
//  #    #  #  # #   #     #  #  #  #         #
//  #    #  #  #  #  ####  #  #  ###         ###

mu bool Thread1_2_Forward_AbsLG(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
( false

  // initial configuration (init)
  |  (
        (exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3,
          Global  t_G.
          (
                 Thread3_1_Forward_AbsLG( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G )
              &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )
              &  t_G.v1 = 0
          )
        )
        &  ContextSwitch_3(s_pc3)
     )

//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
         true
      & (exists                  // There exists an internal state that
           PrCount t_pc1,
           Local   t_CL1,
           Global t_G.
           (    (   Thread1_2_Forward_AbsLG( t_pc1, t_CL1, s_pc2, s_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_1(t_pc1,s_pc1,t_CL1,s_CL1,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_1(t_pc1,t_CL1,s_CL1,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(1, t_pc1, s_pc1, t_CL1, s_CL1, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc1.
             (     Thread1_2_Forward_AbsLG( t_pc1, s_CL1, s_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_1(t_pc1,s_pc1,s_CL1,s_G)    // Control flow statement
             )
         )
    )

);
#size Thread1_2_Forward_AbsLG;
#timer;

 // #####  #   #  ####   #####    #    ####          ###
 //   #    #   #  #   #  #       # #    #  #        #   #
 //   #    #   #  #   #  #      #   #   #  #            #
 //   #    #####  ####   ####   #   #   #  #          ##
 //   #    #   #  # #    #      #####   #  #         #
 //   #    #   #  #  #   #      #   #   #  #        #
 //   #    #   #  #   #  #####  #   #  ####         #####

mu bool Thread2_2_Forward_AbsLG(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
( false

  // initial configuration (init)
  |  (
        (exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3,
          Global  t_G.
          (
                 Thread1_2_Forward_AbsLG( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G )
              &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )
              &  t_G.v1 = 0
          )
        )
        &  ContextSwitch_1(s_pc1)
     )

//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc2,
           Local   t_CL2,
           Global  t_G.
           (    (   Thread2_2_Forward_AbsLG( s_pc1, s_CL1, t_pc2, t_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_2(t_pc2,s_pc2,t_CL2,s_CL2,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_2(t_pc2,t_CL2,s_CL2,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(2, t_pc2, s_pc2, t_CL2, s_CL2, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc2.
             (     Thread2_2_Forward_AbsLG( s_pc1, s_CL1, t_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_2(t_pc2,s_pc2,s_CL2,s_G)    // Control flow statement
             )
         )
    )

);
#size Thread2_2_Forward_AbsLG;
#timer;

// ###   #  #  ###   ####   ##   ###         ####
//  #    #  #  #  #  #     #  #  #  #           #
//  #    ####  #  #  ###   #  #  #  #         ##
//  #    #  #  ###   #     ####  #  #           #
//  #    #  #  # #   #     #  #  #  #        #  #
//  #    #  #  #  #  ####  #  #  ###          ##

mu bool Thread3_2_Forward_AbsLG(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                      // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
( false
  // initial configuration (init)
  |  (
        (exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3,
          Global  t_G.
          (
                 Thread2_2_Forward_AbsLG( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G )
              &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )
              &  t_G.v1 = 0
          )
        )
        &  ContextSwitch_2(s_pc2)
     )

//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc3,
           Local   t_CL3,
           Global  t_G.
           (    (   Thread3_2_Forward_AbsLG( s_pc1, s_CL1, s_pc2, s_CL2, t_pc3, t_CL3, t_G )
                )
               &(
                  ( programInt1_3(t_pc3,s_pc3,t_CL3,s_CL3,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_3(t_pc3,t_CL3,s_CL3,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(3, t_pc3, s_pc3, t_CL3, s_CL3, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc3.
             (     Thread3_2_Forward_AbsLG( s_pc1, s_CL1, s_pc2, s_CL2,t_pc3, s_CL3, s_G )
                 & programInt2_3(t_pc3,s_pc3,s_CL3,s_G)    // Control flow statement
             )
         )
    )

);
#size Thread3_2_Forward_AbsLG;
#timer;


// ####    ###   #   #  #   #  ####          #####
// #   #  #   #  #   #  #   #   #  #             #
// #   #  #   #  #   #  ##  #   #  #            #
// ####   #   #  #   #  # # #   #  #           ##
// # #    #   #  #   #  #  ##   #  #             #
// #  #   #   #  #   #  #   #   #  #         #   #
// #   #   ###    ###   #   #  ####           ###

// FORWARD ABSTRACTION

// ###   #  #  ###   ####   ##   ###          #
//  #    #  #  #  #  #     #  #  #  #        ##
//  #    ####  #  #  ###   #  #  #  #         #
//  #    #  #  ###   #     ####  #  #         #
//  #    #  #  # #   #     #  #  #  #         #
//  #    #  #  #  #  ####  #  #  ###         ###

mu bool Thread1_3_Forward_AbsLG(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
( false

  // initial configuration (init)
  |  (
        (exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3,
          Global  t_G.
          (
                 Thread3_2_Forward_AbsLG( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G )
              &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )
              &  t_G.v1 = 0
          )
        )
        &  ContextSwitch_3(s_pc3)
     )

//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
         true
      & (exists                  // There exists an internal state that
           PrCount t_pc1,
           Local   t_CL1,
           Global t_G.
           (    (   Thread1_3_Forward_AbsLG( t_pc1, t_CL1, s_pc2, s_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_1(t_pc1,s_pc1,t_CL1,s_CL1,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_1(t_pc1,t_CL1,s_CL1,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(1, t_pc1, s_pc1, t_CL1, s_CL1, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc1.
             (     Thread1_3_Forward_AbsLG( t_pc1, s_CL1, s_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_1(t_pc1,s_pc1,s_CL1,s_G)    // Control flow statement
             )
         )
    )

);
#size Thread1_3_Forward_AbsLG;
#timer;

 // #####  #   #  ####   #####    #    ####          ###
 //   #    #   #  #   #  #       # #    #  #        #   #
 //   #    #   #  #   #  #      #   #   #  #            #
 //   #    #####  ####   ####   #   #   #  #          ##
 //   #    #   #  # #    #      #####   #  #         #
 //   #    #   #  #  #   #      #   #   #  #        #
 //   #    #   #  #   #  #####  #   #  ####         #####

mu bool Thread2_3_Forward_AbsLG(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
( false

  // initial configuration (init)
  |  (
        (exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3,
          Global  t_G.
          (
                 Thread1_3_Forward_AbsLG( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G )
              &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )
              &  t_G.v1 = 0
          )
        )
        &  ContextSwitch_1(s_pc1)
     )

//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc2,
           Local   t_CL2,
           Global  t_G.
           (    (   Thread2_3_Forward_AbsLG( s_pc1, s_CL1, t_pc2, t_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_2(t_pc2,s_pc2,t_CL2,s_CL2,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_2(t_pc2,t_CL2,s_CL2,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(2, t_pc2, s_pc2, t_CL2, s_CL2, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc2.
             (     Thread2_3_Forward_AbsLG( s_pc1, s_CL1, t_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_2(t_pc2,s_pc2,s_CL2,s_G)    // Control flow statement
             )
         )
    )

);
#size Thread2_3_Forward_AbsLG;
#timer;

// ###   #  #  ###   ####   ##   ###         ####
//  #    #  #  #  #  #     #  #  #  #           #
//  #    ####  #  #  ###   #  #  #  #         ##
//  #    #  #  ###   #     ####  #  #           #
//  #    #  #  # #   #     #  #  #  #        #  #
//  #    #  #  #  #  ####  #  #  ###          ##

mu bool Thread3_3_Forward_AbsLG(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                      // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
( false
  // initial configuration (init)
  |  (
        (exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3,
          Global  t_G.
          (
                 Thread2_3_Forward_AbsLG( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G )
              &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )
              &  t_G.v1 = 0
          )
        )
        &  ContextSwitch_2(s_pc2)
     )

//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc3,
           Local   t_CL3,
           Global  t_G.
           (    (   Thread3_3_Forward_AbsLG( s_pc1, s_CL1, s_pc2, s_CL2, t_pc3, t_CL3, t_G )
                )
               &(
                  ( programInt1_3(t_pc3,s_pc3,t_CL3,s_CL3,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_3(t_pc3,t_CL3,s_CL3,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(3, t_pc3, s_pc3, t_CL3, s_CL3, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc3.
             (     Thread3_3_Forward_AbsLG( s_pc1, s_CL1, s_pc2, s_CL2,t_pc3, s_CL3, s_G )
                 & programInt2_3(t_pc3,s_pc3,s_CL3,s_G)    // Control flow statement
             )
         )
    )

);
#size Thread3_3_Forward_AbsLG;
#timer;










// ####    ###   #   #  #   #  ####          #####
// #   #  #   #  #   #  #   #   #  #             #
// #   #  #   #  #   #  ##  #   #  #            #
// ####   #   #  #   #  # # #   #  #           ##
// # #    #   #  #   #  #  ##   #  #             #
// #  #   #   #  #   #  #   #   #  #         #   #
// #   #   ###    ###   #   #  ####           ###

// BACKWARD

// ###   #  #  ###   ####   ##   ###         ####
//  #    #  #  #  #  #     #  #  #  #           #
//  #    ####  #  #  ###   #  #  #  #         ##
//  #    #  #  ###   #     ####  #  #           #
//  #    #  #  # #   #     #  #  #  #        #  #
//  #    #  #  #  #  ####  #  #  ###          ##



bool Thread3_3_Forward_AbsLG1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     (
     Thread3_3_Forward_AbsLG(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)
     &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )

     )

 );

mu bool Thread3_3_Backward_AbsLG(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(

     Thread3_3_Forward_AbsLG1(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G)

&

( false

  // initial configuration (init)
  | (
      // target
      (
          target(1, s_pc1)
        | target(2, s_pc2)
        | target(3, s_pc3)
      )

    )


//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc3,
           Local   t_CL3,
           Global  t_G.
           (    (
                  Thread3_3_Backward_AbsLG( s_pc1, s_CL1, s_pc2, s_CL2, t_pc3, t_CL3, t_G )
                )
               &(
                  ( programInt1_3(s_pc3, t_pc3, s_CL3, t_CL3, s_G, t_G)      // Assignment related
                    & CopyVariables_ProgramInt_3(s_pc3, s_CL3, t_CL3, s_G, t_G)   //  Copy others global variable
                  )
                  | programInt3(3, s_pc3, t_pc3, s_CL3, t_CL3, s_G, t_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc3.
             (
                Thread3_3_Backward_AbsLG( s_pc1, s_CL1, s_pc2, s_CL2, t_pc3, s_CL3, s_G )
                 & programInt2_3(s_pc3, t_pc3, s_CL3, s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread3_3_Backward_AbsLG;
//#reset Thread3_3_Forward_AbsLG;
#timer;

 // #####  #   #  ####   #####    #    ####          ###
 //   #    #   #  #   #  #       # #    #  #        #   #
 //   #    #   #  #   #  #      #   #   #  #            #
 //   #    #####  ####   ####   #   #   #  #          ##
 //   #    #   #  # #    #      #####   #  #         #
 //   #    #   #  #  #   #      #   #   #  #        #
 //   #    #   #  #   #  #####  #   #  ####         #####



bool Thread2_3_Forward_AbsLG1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread2_3_Forward_AbsLG(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)
     &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )

 );


mu bool Thread2_3_Backward_AbsLG(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(
  Thread2_3_Forward_AbsLG1(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G)
&

( false

  // initial configuration (init)
  |  (
        (exists
            Local   t_CL1,
            Local   t_CL2,
            Local   t_CL3,
            Global  t_G.
            (
                Thread3_3_Backward_AbsLG( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G )
     &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )
              & t_G.v1 = 0
            )
        )
        &  ContextSwitch_2(s_pc2)
        &  ContextSwitch_3(s_pc3)
     )


//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc2,
           Local   t_CL2,
           Global  t_G.
           (    (   Thread2_3_Backward_AbsLG( s_pc1, s_CL1, t_pc2, t_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_2(s_pc2, t_pc2, s_CL2, t_CL2, s_G, t_G)      // Assignment related
                    & CopyVariables_ProgramInt_2(s_pc2, s_CL2, t_CL2, s_G, t_G)   //  Copy others global variable
                  )
                  | programInt3(2, s_pc2, t_pc2, s_CL2, t_CL2, s_G, t_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc2.
             (     Thread2_3_Backward_AbsLG( s_pc1, s_CL1, t_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_2(s_pc2, t_pc2,s_CL2,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread2_3_Backward_AbsLG;
//#reset Thread2_3_Forward_AbsLG;
#timer;

// ###   #  #  ###   ####   ##   ###          #
//  #    #  #  #  #  #     #  #  #  #        ##
//  #    ####  #  #  ###   #  #  #  #         #
//  #    #  #  ###   #     ####  #  #         #
//  #    #  #  # #   #     #  #  #  #         #
//  #    #  #  #  #  ####  #  #  ###         ###


bool Thread1_3_Forward_AbsLG1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread1_3_Forward_AbsLG(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)
     &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )

 );

mu bool Thread1_3_Backward_AbsLG(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(
  Thread1_3_Forward_AbsLG1( s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G )
&
( false

  // initial configuration (init)
  |  (
        (exists
            Local   t_CL1,
            Local   t_CL2,
            Local   t_CL3,
            Global  t_G.
            (
                Thread2_3_Backward_AbsLG( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G )
     &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )
              & t_G.v1 = 0
            )
        )
        &  ContextSwitch_1(s_pc1)
        &  ContextSwitch_2(s_pc2)
     )

//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
         true
      & (exists                  // There exists an internal state that
           PrCount t_pc1,
           Local   t_CL1,
           Global t_G.
           (    (   Thread1_3_Backward_AbsLG( t_pc1, t_CL1, s_pc2, s_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_1(s_pc1, t_pc1, s_CL1, t_CL1, s_G, t_G)      // Assignment related
                    & CopyVariables_ProgramInt_1(s_pc1, s_CL1, t_CL1, s_G, t_G)   //  Copy others global variable
                  )
                  | programInt3(1, s_pc1, t_pc1, s_CL1, t_CL1, s_G, t_G )   // constrain
                )
           )
      )
    )

  | (
          true
       & (exists PrCount t_pc1.
             (     Thread1_3_Backward_AbsLG( t_pc1, s_CL1, s_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_1(s_pc1,t_pc1,s_CL1,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread1_3_Backward_AbsLG;
//#reset Thread1_3_Forward_AbsLG;
#timer;


// ####    ###   #   #  #   #  ####           ###
 // #   #  #   #  #   #  #   #   #  #         #   #
 // #   #  #   #  #   #  ##  #   #  #             #
 // ####   #   #  #   #  # # #   #  #           ##
 // # #    #   #  #   #  #  ##   #  #          #
 // #  #   #   #  #   #  #   #   #  #         #
 // #   #   ###    ###   #   #  ####          #####

// BACKWARD

// ###   #  #  ###   ####   ##   ###         ####
//  #    #  #  #  #  #     #  #  #  #           #
//  #    ####  #  #  ###   #  #  #  #         ##
//  #    #  #  ###   #     ####  #  #           #
//  #    #  #  # #   #     #  #  #  #        #  #
//  #    #  #  #  #  ####  #  #  ###          ##


bool Thread3_2_Forward_AbsLG1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread3_2_Forward_AbsLG(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)
     &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )

 );

mu bool Thread3_2_Backward_AbsLG(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(
  Thread3_2_Forward_AbsLG1(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G)
&
( false

  // initial configuration (init)
  | (exists
        Local   t_CL1,
        Local   t_CL2,
        Local   t_CL3,
        Global  t_G.
        (
            Thread1_3_Backward_AbsLG(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)
     &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )
          & t_G.v1 = 0
        )
        & ContextSwitch_1(s_pc1)
        & ContextSwitch_3(s_pc3)
    )


//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc3,
           Local   t_CL3,
           Global  t_G.
           (    (
                  Thread3_2_Backward_AbsLG( s_pc1, s_CL1, s_pc2, s_CL2, t_pc3, t_CL3, t_G )
                )
               &(
                  ( programInt1_3(s_pc3, t_pc3, s_CL3, t_CL3, s_G, t_G)      // Assignment related
                    & CopyVariables_ProgramInt_3(s_pc3, s_CL3, t_CL3, s_G, t_G)   //  Copy others global variable
                  )
                  | programInt3(3, s_pc3, t_pc3, s_CL3, t_CL3, s_G, t_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc3.
             (
                Thread3_2_Backward_AbsLG( s_pc1, s_CL1, s_pc2, s_CL2, t_pc3, s_CL3, s_G )
                 & programInt2_3(s_pc3, t_pc3, s_CL3, s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread3_2_Backward_AbsLG;
//#reset Thread3_2_Forward_AbsLG;
#timer;

 // #####  #   #  ####   #####    #    ####          ###
 //   #    #   #  #   #  #       # #    #  #        #   #
 //   #    #   #  #   #  #      #   #   #  #            #
 //   #    #####  ####   ####   #   #   #  #          ##
 //   #    #   #  # #    #      #####   #  #         #
 //   #    #   #  #  #   #      #   #   #  #        #
 //   #    #   #  #   #  #####  #   #  ####         #####


bool Thread2_2_Forward_AbsLG1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread2_2_Forward_AbsLG(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)
     &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )

 );


mu bool Thread2_2_Backward_AbsLG(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(
  Thread2_2_Forward_AbsLG1( s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G )
&
( false

  // initial configuration (init)
  |  ( exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3,
          Global  t_G.
        (
             Thread3_2_Backward_AbsLG( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G )
     &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )
          &  t_G.v1 = 0
        )
        &  ContextSwitch_2(s_pc2)
        &  ContextSwitch_3(s_pc3)
     )


//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc2,
           Local   t_CL2,
           Global  t_G.
           (    (   Thread2_2_Backward_AbsLG( s_pc1, s_CL1, t_pc2, t_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_2(s_pc2, t_pc2, s_CL2, t_CL2, s_G, t_G)      // Assignment related
                    & CopyVariables_ProgramInt_2(s_pc2, s_CL2, t_CL2, s_G, t_G)   //  Copy others global variable
                  )
                  | programInt3(2, s_pc2, t_pc2, s_CL2, t_CL2, s_G, t_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc2.
             (     Thread2_2_Backward_AbsLG( s_pc1, s_CL1, t_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_2(s_pc2, t_pc2,s_CL2,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread2_2_Backward_AbsLG;
//#reset Thread2_2_Forward_AbsLG;
#timer;



// ###   #  #  ###   ####   ##   ###          #
//  #    #  #  #  #  #     #  #  #  #        ##
//  #    ####  #  #  ###   #  #  #  #         #
//  #    #  #  ###   #     ####  #  #         #
//  #    #  #  # #   #     #  #  #  #         #
//  #    #  #  #  #  ####  #  #  ###         ###


bool Thread1_2_Forward_AbsLG1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread1_2_Forward_AbsLG(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)
     &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )

 );

mu bool Thread1_2_Backward_AbsLG(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(
    Thread1_2_Forward_AbsLG1( s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G )
&
( false

  // initial configuration (init)
  |  (exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3,
          Global  t_G.
        (
             Thread2_2_Backward_AbsLG( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G )
     &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )
          &  t_G.v1 = 0
        )
        &  ContextSwitch_1(s_pc1)
        &  ContextSwitch_2(s_pc2)
     )

//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
         true
      & (exists                  // There exists an internal state that
           PrCount t_pc1,
           Local   t_CL1,
           Global t_G.
           (    (   Thread1_2_Backward_AbsLG( t_pc1, t_CL1, s_pc2, s_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_1(s_pc1, t_pc1, s_CL1, t_CL1, s_G, t_G)      // Assignment related
                    & CopyVariables_ProgramInt_1(s_pc1, s_CL1, t_CL1, s_G, t_G)   //  Copy others global variable
                  )
                  | programInt3(1, s_pc1, t_pc1, s_CL1, t_CL1, s_G, t_G )   // constrain
                )
           )
      )
    )

  | (
          true
       & (exists PrCount t_pc1.
             (     Thread1_2_Backward_AbsLG( t_pc1, s_CL1, s_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_1(s_pc1,t_pc1,s_CL1,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread1_2_Backward_AbsLG;
//#reset Thread1_2_Forward_AbsLG;
#timer;


// ####    ###   #   #  #   #  ####            #
// #   #  #   #  #   #  #   #   #  #          ##
// #   #  #   #  #   #  ##  #   #  #         # #
// ####   #   #  #   #  # # #   #  #           #
// # #    #   #  #   #  #  ##   #  #           #
// #  #   #   #  #   #  #   #   #  #           #
// #   #   ###    ###   #   #  ####          #####

// BACKWARD


// ###   #  #  ###   ####   ##   ###         ####
//  #    #  #  #  #  #     #  #  #  #           #
//  #    ####  #  #  ###   #  #  #  #         ##
//  #    #  #  ###   #     ####  #  #           #
//  #    #  #  # #   #     #  #  #  #        #  #
//  #    #  #  #  #  ####  #  #  ###          ##


bool Thread3_1_Forward_AbsLG1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread3_1_Forward_AbsLG(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)
     &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )

 );


mu bool Thread3_1_Backward_AbsLG(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(    Thread3_1_Forward_AbsLG1(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G)
&
( false

  // initial configuration (init)
  | (exists
        Local   t_CL1,
        Local   t_CL2,
        Local   t_CL3,
        Global  t_G.
        (
            Thread1_2_Backward_AbsLG(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)
     &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )
          & t_G.v1 = 0
        )
        & ContextSwitch_1(s_pc1)
        & ContextSwitch_3(s_pc3)
    )


//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc3,
           Local   t_CL3,
           Global  t_G.
           (    (
                  Thread3_1_Backward_AbsLG( s_pc1, s_CL1, s_pc2, s_CL2, t_pc3, t_CL3, t_G )
                )
               &(
                  ( programInt1_3(s_pc3, t_pc3, s_CL3, t_CL3, s_G, t_G)      // Assignment related
                    & CopyVariables_ProgramInt_3(s_pc3, s_CL3, t_CL3, s_G, t_G)   //  Copy others global variable
                  )
                  | programInt3(3, s_pc3, t_pc3, s_CL3, t_CL3, s_G, t_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc3.
             (
                Thread3_1_Backward_AbsLG( s_pc1, s_CL1, s_pc2, s_CL2, t_pc3, s_CL3, s_G )
                 & programInt2_3(s_pc3, t_pc3, s_CL3, s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread3_1_Backward_AbsLG;
//#reset Thread3_1_Forward_AbsLG;
#timer;

 // #####  #   #  ####   #####    #    ####          ###
 //   #    #   #  #   #  #       # #    #  #        #   #
 //   #    #   #  #   #  #      #   #   #  #            #
 //   #    #####  ####   ####   #   #   #  #          ##
 //   #    #   #  # #    #      #####   #  #         #
 //   #    #   #  #  #   #      #   #   #  #        #
 //   #    #   #  #   #  #####  #   #  ####         #####


bool Thread2_1_Forward_AbsLG1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread2_1_Forward_AbsLG(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)
     &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )

 );


mu bool Thread2_1_Backward_AbsLG(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(    Thread2_1_Forward_AbsLG1( s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G )
&
( false

  // initial configuration (init)
  |  ( exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3,
          Global  t_G.
        (
             Thread3_1_Backward_AbsLG( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G )
     &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )
          &  t_G.v1 = 0
        )
        &  ContextSwitch_2(s_pc2)
        &  ContextSwitch_3(s_pc3)
     )


//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc2,
           Local   t_CL2,
           Global  t_G.
           (    (   Thread2_1_Backward_AbsLG( s_pc1, s_CL1, t_pc2, t_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_2(s_pc2, t_pc2, s_CL2, t_CL2, s_G, t_G)      // Assignment related
                    & CopyVariables_ProgramInt_2(s_pc2, s_CL2, t_CL2, s_G, t_G)   //  Copy others global variable
                  )
                  | programInt3(2, s_pc2, t_pc2, s_CL2, t_CL2, s_G, t_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc2.
             (     Thread2_1_Backward_AbsLG( s_pc1, s_CL1, t_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_2(s_pc2, t_pc2,s_CL2,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread2_1_Backward_AbsLG;
//#reset Thread2_1_Forward_AbsLG;
#timer;



// ###   #  #  ###   ####   ##   ###          #
//  #    #  #  #  #  #     #  #  #  #        ##
//  #    ####  #  #  ###   #  #  #  #         #
//  #    #  #  ###   #     ####  #  #         #
//  #    #  #  # #   #     #  #  #  #         #
//  #    #  #  #  #  ####  #  #  ###         ###


bool Thread1_1_Forward_AbsLG1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread1_1_Forward_AbsLG(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)
     &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )

 );

mu bool Thread1_1_Backward_AbsLG(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(   Thread1_1_Forward_AbsLG1( s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G )
&
( false

  // initial configuration (init)
  |  (exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3,
          Global  t_G.
        (
            Thread2_1_Backward_AbsLG( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G )
     &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )
          &  t_G.v1 = 0
        )
        &  ContextSwitch_1(s_pc1)
        &  ContextSwitch_2(s_pc2)
     )

//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
         true
      & (exists                  // There exists an internal state that
           PrCount t_pc1,
           Local   t_CL1,
           Global t_G.
           (    (   Thread1_1_Backward_AbsLG( t_pc1, t_CL1, s_pc2, s_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_1(s_pc1, t_pc1, s_CL1, t_CL1, s_G, t_G)      // Assignment related
                    & CopyVariables_ProgramInt_1(s_pc1, s_CL1, t_CL1, s_G, t_G)   //  Copy others global variable
                  )
                  | programInt3(1, s_pc1, t_pc1, s_CL1, t_CL1, s_G, t_G )   // constrain
                )
           )
      )
    )

  | (

          true
       & (exists PrCount t_pc1.
             (     Thread1_1_Backward_AbsLG( t_pc1, s_CL1, s_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_1(s_pc1,t_pc1,s_CL1,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread1_1_Backward_AbsLG;
//#reset Thread1_1_Forward_AbsLG;
#timer;


// ####    ###   #   #  #   #  ####            #
// #   #  #   #  #   #  #   #   #  #          # #
// #   #  #   #  #   #  ##  #   #  #         #   #
// ####   #   #  #   #  # # #   #  #         #   #
// # #    #   #  #   #  #  ##   #  #         #   #
// #  #   #   #  #   #  #   #   #  #          # #
// #   #   ###    ###   #   #  ####            #

// BACKWARD

// ###   #  #  ###   ####   ##   ###         ####
//  #    #  #  #  #  #     #  #  #  #           #
//  #    ####  #  #  ###   #  #  #  #         ##
//  #    #  #  ###   #     ####  #  #           #
//  #    #  #  # #   #     #  #  #  #        #  #
//  #    #  #  #  #  ####  #  #  ###          ##


bool Thread3_0_Forward_AbsLG1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread3_0_Forward_AbsLG(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)
     &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )

 );


mu bool Thread3_0_Backward_AbsLG(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(
  Thread3_0_Forward_AbsLG1(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G)
&
( false

  // initial configuration (init)
  | (exists
        Local   t_CL1,
        Local   t_CL2,
        Local   t_CL3,
        Global  t_G.
        (
            Thread1_1_Backward_AbsLG(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)
     &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )
          & t_G.v1 = 0
        )
        & ContextSwitch_1(s_pc1)
        & ContextSwitch_3(s_pc3)
    )


//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc3,
           Local   t_CL3,
           Global  t_G.
           (    (
                  Thread3_0_Backward_AbsLG( s_pc1, s_CL1, s_pc2, s_CL2, t_pc3, t_CL3, t_G )
                )
               &(
                  ( programInt1_3(s_pc3, t_pc3, s_CL3, t_CL3, s_G, t_G)      // Assignment related
                    & CopyVariables_ProgramInt_3(s_pc3, s_CL3, t_CL3, s_G, t_G)   //  Copy others global variable
                  )
                  | programInt3(3, s_pc3, t_pc3, s_CL3, t_CL3, s_G, t_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc3.
             (
                Thread3_0_Backward_AbsLG( s_pc1, s_CL1, s_pc2, s_CL2, t_pc3, s_CL3, s_G )
                 & programInt2_3(s_pc3, t_pc3, s_CL3, s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread3_0_Backward_AbsLG;
//#reset Thread3_0_Forward_AbsLG;
#timer;

 // #####  #   #  ####   #####    #    ####          ###
 //   #    #   #  #   #  #       # #    #  #        #   #
 //   #    #   #  #   #  #      #   #   #  #            #
 //   #    #####  ####   ####   #   #   #  #          ##
 //   #    #   #  # #    #      #####   #  #         #
 //   #    #   #  #  #   #      #   #   #  #        #
 //   #    #   #  #   #  #####  #   #  ####         #####


bool Thread2_0_Forward_AbsLG1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread2_0_Forward_AbsLG(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)
     &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )

 );

mu bool Thread2_0_Backward_AbsLG(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(
   Thread2_0_Forward_AbsLG1( s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G )
&
( false

  // initial configuration (init)
  |  ( exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3,
          Global  t_G.
        (
             Thread3_0_Backward_AbsLG( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G )
     &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )
          &  t_G.v1 = 0
        )
        &  ContextSwitch_2(s_pc2)
        &  ContextSwitch_3(s_pc3)
     )


//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc2,
           Local   t_CL2,
           Global  t_G.
           (    (   Thread2_0_Backward_AbsLG( s_pc1, s_CL1, t_pc2, t_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_2(s_pc2, t_pc2, s_CL2, t_CL2, s_G, t_G)      // Assignment related
                    & CopyVariables_ProgramInt_2(s_pc2, s_CL2, t_CL2, s_G, t_G)   //  Copy others global variable
                  )
                  | programInt3(2, s_pc2, t_pc2, s_CL2, t_CL2, s_G, t_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc2.
             (     Thread2_0_Backward_AbsLG( s_pc1, s_CL1, t_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_2(s_pc2, t_pc2,s_CL2,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread2_0_Backward_AbsLG;
//#reset Thread2_0_Forward_AbsLG;
#timer;



// ###   #  #  ###   ####   ##   ###          #
//  #    #  #  #  #  #     #  #  #  #        ##
//  #    ####  #  #  ###   #  #  #  #         #
//  #    #  #  ###   #     ####  #  #         #
//  #    #  #  # #   #     #  #  #  #         #
//  #    #  #  #  #  ####  #  #  ###         ###

bool Thread1_0_Forward_AbsLG1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread1_0_Forward_AbsLG(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)
     &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )

 );

mu bool Thread1_0_Backward_AbsLG(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(  Thread1_0_Forward_AbsLG1( s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G )
&
( false

  // initial configuration (init)
  |  (exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3,
          Global  t_G.
        (
             Thread2_0_Backward_AbsLG( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G )
     &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )
          &  t_G.v1 = 0
        )
        &  ContextSwitch_1(s_pc1)
        &  ContextSwitch_2(s_pc2)
     )

//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
         true
      & (exists                  // There exists an internal state that
           PrCount t_pc1,
           Local   t_CL1,
           Global t_G.
           (    (   Thread1_0_Backward_AbsLG( t_pc1, t_CL1, s_pc2, s_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_1(s_pc1, t_pc1, s_CL1, t_CL1, s_G, t_G)      // Assignment related
                    & CopyVariables_ProgramInt_1(s_pc1, s_CL1, t_CL1, s_G, t_G)   //  Copy others global variable
                  )
                  | programInt3(1, s_pc1, t_pc1, s_CL1, t_CL1, s_G, t_G )   // constrain
                )
           )
      )
    )

  | (

          true
       & (exists PrCount t_pc1.
             (     Thread1_0_Backward_AbsLG( t_pc1, s_CL1, s_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_1(s_pc1,t_pc1,s_CL1,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread1_0_Backward_AbsLG;
//#reset Thread1_0_Forward_AbsLG;
#timer;



//
// #        #    #   #  #####  ####            #      #
// #       # #   #   #  #      #   #          ##     # #
// #      #   #   # #   #      #   #         # #    #   #
// #      #   #    #    ####   ####            #    #   #
// #      #####    #    #      # #             #    #####
// #      #   #    #    #      #  #            #    #   #
// #####  #   #    #    #####  #   #         #####  #   #
//





// ####    ###   #   #  #   #  ####            #
// #   #  #   #  #   #  #   #   #  #          # #
// #   #  #   #  #   #  ##  #   #  #         #   #
// ####   #   #  #   #  # # #   #  #         #   #
// # #    #   #  #   #  #  ##   #  #         #   #
// #  #   #   #  #   #  #   #   #  #          # #
// #   #   ###    ###   #   #  ####            #

// Forward abstraction

// ###   #  #  ###   ####   ##   ###          #
//  #    #  #  #  #  #     #  #  #  #        ##
//  #    ####  #  #  ###   #  #  #  #         #
//  #    #  #  ###   #     ####  #  #         #
//  #    #  #  # #   #     #  #  #  #         #
//  #    #  #  #  #  ####  #  #  ###         ###



mu bool Thread1_0_Forward_AbsLG_again(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                      // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(
Thread1_0_Backward_AbsLG(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G) &
( false

  // initial configuration (init)
  |
  (
           initPC(s_pc1)              // Initial PC
         & initPC(s_pc2)              // Initial PC
         & initPC(s_pc3)              // Initial PC
         & GlobalInit(s_G)
     )

//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
         true
      & (exists                  // There exists an internal state that
           PrCount t_pc1,
           Local   t_CL1,
           Global t_G.
           (    (   Thread1_0_Forward_AbsLG_again( t_pc1, t_CL1, s_pc2, s_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  (
                    programInt1_1(t_pc1,s_pc1,t_CL1,s_CL1,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_1(t_pc1,t_CL1,s_CL1,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(1, t_pc1, s_pc1, t_CL1, s_CL1, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (

          true
       & (exists PrCount t_pc1.
             (     Thread1_0_Forward_AbsLG_again( t_pc1, s_CL1, s_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_1(t_pc1,s_pc1,s_CL1,s_G)    // Control flow statement
             )
         )
    )

)
);
#size Thread1_0_Forward_AbsLG_again;
#timer;


 // #####  #   #  ####   #####    #    ####          ###
 //   #    #   #  #   #  #       # #    #  #        #   #
 //   #    #   #  #   #  #      #   #   #  #            #
 //   #    #####  ####   ####   #   #   #  #          ##
 //   #    #   #  # #    #      #####   #  #         #
 //   #    #   #  #  #   #      #   #   #  #        #
 //   #    #   #  #   #  #####  #   #  ####         #####


bool Init_Thread2_0_Forward_AbsLG_again(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(false
  // initial configuration (init)
  |  (
        (exists
               Local      t_CL1,
               Local      t_CL2,
               Local      t_CL3,
               Global     t_G.
              (
                    Thread1_0_Forward_AbsLG_again( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G )
     &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )
                 &  t_G.v1 = 0
              )
        )
        &  ContextSwitch_1(s_pc1)
     )
);
#size Init_Thread2_0_Forward_AbsLG_again;
#timer;


mu bool Thread2_0_Forward_AbsLG_again(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable

 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(
  Thread2_0_Backward_AbsLG(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G)&
  ( false

  // initial configuration (init)
  |
  (Init_Thread2_0_Forward_AbsLG_again(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G)
  )


//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc2,
           Local   t_CL2,
           Global  t_G.
           (    (   Thread2_0_Forward_AbsLG_again( s_pc1, s_CL1, t_pc2, t_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_2(t_pc2,s_pc2,t_CL2,s_CL2,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_2(t_pc2,t_CL2,s_CL2,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(2, t_pc2, s_pc2, t_CL2, s_CL2, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc2.
             (     Thread2_0_Forward_AbsLG_again( s_pc1, s_CL1, t_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_2(t_pc2,s_pc2,s_CL2,s_G)    // Control flow statement
             )
         )
    )

));
#size Thread2_0_Forward_AbsLG_again;
#timer;

// ###   #  #  ###   ####   ##   ###         ####
//  #    #  #  #  #  #     #  #  #  #           #
//  #    ####  #  #  ###   #  #  #  #         ##
//  #    #  #  ###   #     ####  #  #           #
//  #    #  #  # #   #     #  #  #  #        #  #
//  #    #  #  #  #  ####  #  #  ###          ##

bool Init_Thread3_0_Forward_AbsLG_again(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(
(
    (exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3,
          Global  t_G.
          (
                 Thread2_0_Forward_AbsLG_again( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G )
     &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )
              &  t_G.v1 = 0
          )
        )
        &  ContextSwitch_2(s_pc2)
     )
);
#size Init_Thread3_0_Forward_AbsLG_again;
#timer;

mu bool Thread3_0_Forward_AbsLG_again(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable

 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(
   Thread3_0_Backward_AbsLG(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G)&

( false

  // initial configuration (init)
  |
  ( Init_Thread3_0_Forward_AbsLG_again(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G)
  )


//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc3,
           Local   t_CL3,
           Global  t_G.
           (    (   Thread3_0_Forward_AbsLG_again( s_pc1, s_CL1, s_pc2, s_CL2, t_pc3, t_CL3, t_G )
                )
               &(
                  ( programInt1_3(t_pc3,s_pc3,t_CL3,s_CL3,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_3(t_pc3,t_CL3,s_CL3,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(3, t_pc3, s_pc3, t_CL3, s_CL3, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc3.
             (     Thread3_0_Forward_AbsLG_again( s_pc1, s_CL1, s_pc2, s_CL2,t_pc3, s_CL3, s_G )
                 & programInt2_3(t_pc3,s_pc3,s_CL3,s_G)    // Control flow statement
             )
         )
    )

)
);
#size Thread3_0_Forward_AbsLG_again;
#timer;


// ####    ###   #   #  #   #  ####                   #
// #   #  #   #  #   #  #   #   #  #                 ##
// #   #  #   #  #   #  ##  #   #  #                # #
// ####   #   #  #   #  # # #   #  #                  #
// # #    #   #  #   #  #  ##   #  #                  #
// #  #   #   #  #   #  #   #   #  #                  #
// #   #   ###    ###   #   #  ####                 #####

// FORWARD ABSTRACTION


// ###   #  #  ###   ####   ##   ###          #
//  #    #  #  #  #  #     #  #  #  #        ##
//  #    ####  #  #  ###   #  #  #  #         #
//  #    #  #  ###   #     ####  #  #         #
//  #    #  #  # #   #     #  #  #  #         #
//  #    #  #  #  #  ####  #  #  ###         ###

bool Init_Thread1_1_Forward_AbsLG_again(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
((
        (exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3,
          Global  t_G.
          (
                 Thread3_0_Forward_AbsLG_again( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G )
     &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )
              &  t_G.v1 = 0
          )
        )
        &  ContextSwitch_3(s_pc3)
     )
);

#size Init_Thread1_1_Forward_AbsLG_again;
#timer;

mu bool Thread1_1_Forward_AbsLG_again(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(
  Thread1_1_Backward_AbsLG(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G)&

( false

  // initial configuration (init)
  |  (Init_Thread1_1_Forward_AbsLG_again(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G)
  )

//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
         true
      & (exists                  // There exists an internal state that
           PrCount t_pc1,
           Local   t_CL1,
           Global t_G.
           (    (   Thread1_1_Forward_AbsLG_again( t_pc1, t_CL1, s_pc2, s_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_1(t_pc1,s_pc1,t_CL1,s_CL1,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_1(t_pc1,t_CL1,s_CL1,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(1, t_pc1, s_pc1, t_CL1, s_CL1, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc1.
             (     Thread1_1_Forward_AbsLG_again( t_pc1, s_CL1, s_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_1(t_pc1,s_pc1,s_CL1,s_G)    // Control flow statement
             )
         )
    )

));
#size Thread1_1_Forward_AbsLG_again;
#timer;

 // #####  #   #  ####   #####    #    ####          ###
 //   #    #   #  #   #  #       # #    #  #        #   #
 //   #    #   #  #   #  #      #   #   #  #            #
 //   #    #####  ####   ####   #   #   #  #          ##
 //   #    #   #  # #    #      #####   #  #         #
 //   #    #   #  #  #   #      #   #   #  #        #
 //   #    #   #  #   #  #####  #   #  ####         #####

bool Init_Thread2_1_Forward_AbsLG_again(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(
(
        (exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3,
          Global  t_G.
          (
                 Thread1_1_Forward_AbsLG_again( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G )
     &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )
              &  t_G.v1 = 0
          )
        )
        &  ContextSwitch_1(s_pc1)
     )
);
#size Init_Thread2_1_Forward_AbsLG_again;
#timer;
mu bool Thread2_1_Forward_AbsLG_again(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(
  Thread2_1_Backward_AbsLG(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G) &

( false

  // initial configuration (init)
  |  (Init_Thread2_1_Forward_AbsLG_again(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G)
  )

//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc2,
           Local   t_CL2,
           Global  t_G.
           (    (
                    Thread2_1_Forward_AbsLG_again( s_pc1, s_CL1, t_pc2, t_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_2(t_pc2,s_pc2,t_CL2,s_CL2,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_2(t_pc2,t_CL2,s_CL2,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(2, t_pc2, s_pc2, t_CL2, s_CL2, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc2.
             (
                  Thread2_1_Forward_AbsLG_again( s_pc1, s_CL1, t_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_2(t_pc2,s_pc2,s_CL2,s_G)    // Control flow statement
             )
         )
    )

));
#size Thread2_1_Forward_AbsLG_again;
#timer;

// ###   #  #  ###   ####   ##   ###         ####
//  #    #  #  #  #  #     #  #  #  #           #
//  #    ####  #  #  ###   #  #  #  #         ##
//  #    #  #  ###   #     ####  #  #           #
//  #    #  #  # #   #     #  #  #  #        #  #
//  #    #  #  #  #  ####  #  #  ###          ##

bool Init_Thread3_1_Forward_AbsLG_again(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(
(
        (exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3,
          Global  t_G.
          (
                 Thread2_1_Forward_AbsLG_again( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G )
     &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )
              &  t_G.v1 = 0
          )
        )
        &  ContextSwitch_2(s_pc2)
     )
);
#size Init_Thread3_1_Forward_AbsLG_again;
#timer;


mu bool Thread3_1_Forward_AbsLG_again(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                      // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(
  Thread3_1_Backward_AbsLG(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G)&

( false
  // initial configuration (init)
  |  (Init_Thread3_1_Forward_AbsLG_again(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G)
  )





//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc3,
           Local   t_CL3,
           Global  t_G.
           (    (   Thread3_1_Forward_AbsLG_again( s_pc1, s_CL1, s_pc2, s_CL2, t_pc3, t_CL3, t_G )
                )
               &(
                  ( programInt1_3(t_pc3,s_pc3,t_CL3,s_CL3,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_3(t_pc3,t_CL3,s_CL3,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(3, t_pc3, s_pc3, t_CL3, s_CL3, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc3.
             (     Thread3_1_Forward_AbsLG_again( s_pc1, s_CL1, s_pc2, s_CL2,t_pc3, s_CL3, s_G )
                 & programInt2_3(t_pc3,s_pc3,s_CL3,s_G)    // Control flow statement
             )
         )
    )

));
#size Thread3_1_Forward_AbsLG_again;
#timer;



// ####    ###   #   #  #   #  ####           ###
// #   #  #   #  #   #  #   #   #  #         #   #
// #   #  #   #  #   #  ##  #   #  #             #
// ####   #   #  #   #  # # #   #  #           ##
// # #    #   #  #   #  #  ##   #  #          #
// #  #   #   #  #   #  #   #   #  #         #
// #   #   ###    ###   #   #  ####          #####

// FORWARD ABSTRACTION


// ###   #  #  ###   ####   ##   ###          #
//  #    #  #  #  #  #     #  #  #  #        ##
//  #    ####  #  #  ###   #  #  #  #         #
//  #    #  #  ###   #     ####  #  #         #
//  #    #  #  # #   #     #  #  #  #         #
//  #    #  #  #  #  ####  #  #  ###         ###

bool Init_Thread1_2_Forward_AbsLG_again(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(
(
        (exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3,
          Global  t_G.
          (
                 Thread3_1_Forward_AbsLG_again( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G )
     &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )
              &  t_G.v1 = 0
          )
        )
        &  ContextSwitch_3(s_pc3)
     )
);
#size Init_Thread1_2_Forward_AbsLG_again;
#timer;


mu bool Thread1_2_Forward_AbsLG_again(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(Thread1_2_Backward_AbsLG(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G) &
( false

  // initial configuration (init)
  |  Init_Thread1_2_Forward_AbsLG_again(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G)

//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
         true
      & (exists                  // There exists an internal state that
           PrCount t_pc1,
           Local   t_CL1,
           Global t_G.
           (    (   Thread1_2_Forward_AbsLG_again( t_pc1, t_CL1, s_pc2, s_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_1(t_pc1,s_pc1,t_CL1,s_CL1,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_1(t_pc1,t_CL1,s_CL1,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(1, t_pc1, s_pc1, t_CL1, s_CL1, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc1.
             (     Thread1_2_Forward_AbsLG_again( t_pc1, s_CL1, s_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_1(t_pc1,s_pc1,s_CL1,s_G)    // Control flow statement
             )
         )
    )

));
#size Thread1_2_Forward_AbsLG_again;
#timer;

 // #####  #   #  ####   #####    #    ####          ###
 //   #    #   #  #   #  #       # #    #  #        #   #
 //   #    #   #  #   #  #      #   #   #  #            #
 //   #    #####  ####   ####   #   #   #  #          ##
 //   #    #   #  # #    #      #####   #  #         #
 //   #    #   #  #  #   #      #   #   #  #        #
 //   #    #   #  #   #  #####  #   #  ####         #####
bool Init_Thread2_2_Forward_AbsLG_again(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
((
        (exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3,
          Global  t_G.
          (
                 Thread1_2_Forward_AbsLG_again( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G )
     &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )
              &  t_G.v1 = 0
          )
        )
        &  ContextSwitch_1(s_pc1)
     )
);
#size Init_Thread2_2_Forward_AbsLG_again;
#timer;

mu bool Thread2_2_Forward_AbsLG_again(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(Thread2_2_Backward_AbsLG(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G) &
( false

  // initial configuration (init)
  |  Init_Thread2_2_Forward_AbsLG_again(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G)

//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc2,
           Local   t_CL2,
           Global  t_G.
           (    (   Thread2_2_Forward_AbsLG_again( s_pc1, s_CL1, t_pc2, t_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_2(t_pc2,s_pc2,t_CL2,s_CL2,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_2(t_pc2,t_CL2,s_CL2,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(2, t_pc2, s_pc2, t_CL2, s_CL2, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc2.
             (     Thread2_2_Forward_AbsLG_again( s_pc1, s_CL1, t_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_2(t_pc2,s_pc2,s_CL2,s_G)    // Control flow statement
             )
         )
    )

));
#size Thread2_2_Forward_AbsLG_again;
#timer;

// ###   #  #  ###   ####   ##   ###         ####
//  #    #  #  #  #  #     #  #  #  #           #
//  #    ####  #  #  ###   #  #  #  #         ##
//  #    #  #  ###   #     ####  #  #           #
//  #    #  #  # #   #     #  #  #  #        #  #
//  #    #  #  #  #  ####  #  #  ###          ##
bool Init_Thread3_2_Forward_AbsLG_again(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(
(
        (exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3,
          Global  t_G.
          (
                 Thread2_2_Forward_AbsLG_again( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G )
     &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )
              &  t_G.v1 = 0
          )
        )
        &  ContextSwitch_2(s_pc2)
     )
);
#size Init_Thread3_2_Forward_AbsLG_again;
#timer;

mu bool Thread3_2_Forward_AbsLG_again(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                      // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(Thread3_2_Backward_AbsLG(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G) &
( false
  // initial configuration (init)
  |  Init_Thread3_2_Forward_AbsLG_again(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G)

//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc3,
           Local   t_CL3,
           Global  t_G.
           (    (   Thread3_2_Forward_AbsLG_again( s_pc1, s_CL1, s_pc2, s_CL2, t_pc3, t_CL3, t_G )
                )
               &(
                  ( programInt1_3(t_pc3,s_pc3,t_CL3,s_CL3,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_3(t_pc3,t_CL3,s_CL3,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(3, t_pc3, s_pc3, t_CL3, s_CL3, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc3.
             (     Thread3_2_Forward_AbsLG_again( s_pc1, s_CL1, s_pc2, s_CL2,t_pc3, s_CL3, s_G )
                 & programInt2_3(t_pc3,s_pc3,s_CL3,s_G)    // Control flow statement
             )
         )
    )

));
#size Thread3_2_Forward_AbsLG_again;
#timer;


// ####    ###   #   #  #   #  ####          #####
// #   #  #   #  #   #  #   #   #  #             #
// #   #  #   #  #   #  ##  #   #  #            #
// ####   #   #  #   #  # # #   #  #           ##
// # #    #   #  #   #  #  ##   #  #             #
// #  #   #   #  #   #  #   #   #  #         #   #
// #   #   ###    ###   #   #  ####           ###

// FORWARD ABSTRACTION

// ###   #  #  ###   ####   ##   ###          #
//  #    #  #  #  #  #     #  #  #  #        ##
//  #    ####  #  #  ###   #  #  #  #         #
//  #    #  #  ###   #     ####  #  #         #
//  #    #  #  # #   #     #  #  #  #         #
//  #    #  #  #  #  ####  #  #  ###         ###
bool Init_Thread1_3_Forward_AbsLG_again(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
((
        (exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3,
          Global  t_G.
          (
                 Thread3_2_Forward_AbsLG_again( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G )
     &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )
              &  t_G.v1 = 0
          )
        )
        &  ContextSwitch_3(s_pc3)
     )
);
#size Init_Thread1_3_Forward_AbsLG_again;
#timer;

mu bool Thread1_3_Forward_AbsLG_again(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(Thread1_3_Backward_AbsLG(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G) &
( false

  // initial configuration (init)
  |  Init_Thread1_3_Forward_AbsLG_again(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G)

//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
         true
      & (exists                  // There exists an internal state that
           PrCount t_pc1,
           Local   t_CL1,
           Global t_G.
           (    (   Thread1_3_Forward_AbsLG_again( t_pc1, t_CL1, s_pc2, s_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_1(t_pc1,s_pc1,t_CL1,s_CL1,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_1(t_pc1,t_CL1,s_CL1,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(1, t_pc1, s_pc1, t_CL1, s_CL1, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc1.
             (     Thread1_3_Forward_AbsLG_again( t_pc1, s_CL1, s_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_1(t_pc1,s_pc1,s_CL1,s_G)    // Control flow statement
             )
         )
    )

));
#size Thread1_3_Forward_AbsLG_again;
#timer;

 // #####  #   #  ####   #####    #    ####          ###
 //   #    #   #  #   #  #       # #    #  #        #   #
 //   #    #   #  #   #  #      #   #   #  #            #
 //   #    #####  ####   ####   #   #   #  #          ##
 //   #    #   #  # #    #      #####   #  #         #
 //   #    #   #  #  #   #      #   #   #  #        #
 //   #    #   #  #   #  #####  #   #  ####         #####
bool Init_Thread2_3_Forward_AbsLG_again(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(
(
        (exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3,
          Global  t_G.
          (
                 Thread1_3_Forward_AbsLG_again( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G )
     &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )
              &  t_G.v1 = 0
          )
        )
        &  ContextSwitch_1(s_pc1)
     )
);
#size Init_Thread2_3_Forward_AbsLG_again;
#timer;

mu bool Thread2_3_Forward_AbsLG_again(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(Thread2_3_Backward_AbsLG(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G) &
( false

  // initial configuration (init)
  |  Init_Thread2_3_Forward_AbsLG_again(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G)

//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc2,
           Local   t_CL2,
           Global  t_G.
           (    (   Thread2_3_Forward_AbsLG_again( s_pc1, s_CL1, t_pc2, t_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_2(t_pc2,s_pc2,t_CL2,s_CL2,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_2(t_pc2,t_CL2,s_CL2,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(2, t_pc2, s_pc2, t_CL2, s_CL2, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc2.
             (     Thread2_3_Forward_AbsLG_again( s_pc1, s_CL1, t_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_2(t_pc2,s_pc2,s_CL2,s_G)    // Control flow statement
             )
         )
    )

));
#size Thread2_3_Forward_AbsLG_again;
#timer;

// ###   #  #  ###   ####   ##   ###         ####
//  #    #  #  #  #  #     #  #  #  #           #
//  #    ####  #  #  ###   #  #  #  #         ##
//  #    #  #  ###   #     ####  #  #           #
//  #    #  #  # #   #     #  #  #  #        #  #
//  #    #  #  #  #  ####  #  #  ###          ##
bool Init_Thread3_3_Forward_AbsLG_again(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(
(
        (exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3,
          Global  t_G.
          (
                 Thread2_3_Forward_AbsLG_again( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G )
     &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )
              &  t_G.v1 = 0
          )
        )
        &  ContextSwitch_2(s_pc2)
     )
);
#size Init_Thread3_3_Forward_AbsLG_again;
#timer;

mu bool Thread3_3_Forward_AbsLG_again(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                      // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(Thread3_3_Backward_AbsLG(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G) &
( false
  // initial configuration (init)
  |  Init_Thread3_3_Forward_AbsLG_again(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G)

//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc3,
           Local   t_CL3,
           Global  t_G.
           (    (   Thread3_3_Forward_AbsLG_again( s_pc1, s_CL1, s_pc2, s_CL2, t_pc3, t_CL3, t_G )
                )
               &(
                  ( programInt1_3(t_pc3,s_pc3,t_CL3,s_CL3,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_3(t_pc3,t_CL3,s_CL3,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(3, t_pc3, s_pc3, t_CL3, s_CL3, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc3.
             (     Thread3_3_Forward_AbsLG_again( s_pc1, s_CL1, s_pc2, s_CL2,t_pc3, s_CL3, s_G )
                 & programInt2_3(t_pc3,s_pc3,s_CL3,s_G)    // Control flow statement
             )
         )
    )

));
#size Thread3_3_Forward_AbsLG_again;
#timer;










// ####    ###   #   #  #   #  ####          #####
// #   #  #   #  #   #  #   #   #  #             #
// #   #  #   #  #   #  ##  #   #  #            #
// ####   #   #  #   #  # # #   #  #           ##
// # #    #   #  #   #  #  ##   #  #             #
// #  #   #   #  #   #  #   #   #  #         #   #
// #   #   ###    ###   #   #  ####           ###

// BACKWARD

// ###   #  #  ###   ####   ##   ###         ####
//  #    #  #  #  #  #     #  #  #  #           #
//  #    ####  #  #  ###   #  #  #  #         ##
//  #    #  #  ###   #     ####  #  #           #
//  #    #  #  # #   #     #  #  #  #        #  #
//  #    #  #  #  #  ####  #  #  ###          ##



bool Thread3_3_Forward_AbsLG_again1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread3_3_Forward_AbsLG_again(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)
     &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )

 );

mu bool Thread3_3_Backward_AbsLG_again(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(

     Thread3_3_Forward_AbsLG_again1(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G)

&

( false

  // initial configuration (init)
  | (
      // target
      (
          target(1, s_pc1)
        | target(2, s_pc2)
        | target(3, s_pc3)
      )

    )


//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc3,
           Local   t_CL3,
           Global  t_G.
           (    (
                  Thread3_3_Backward_AbsLG_again( s_pc1, s_CL1, s_pc2, s_CL2, t_pc3, t_CL3, t_G )
                )
               &(
                  ( programInt1_3(s_pc3, t_pc3, s_CL3, t_CL3, s_G, t_G)      // Assignment related
                    & CopyVariables_ProgramInt_3(s_pc3, s_CL3, t_CL3, s_G, t_G)   //  Copy others global variable
                  )
                  | programInt3(3, s_pc3, t_pc3, s_CL3, t_CL3, s_G, t_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc3.
             (
                Thread3_3_Backward_AbsLG_again( s_pc1, s_CL1, s_pc2, s_CL2, t_pc3, s_CL3, s_G )
                 & programInt2_3(s_pc3, t_pc3, s_CL3, s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread3_3_Backward_AbsLG_again;
//#reset Thread3_3_Forward_AbsLG_again;
#timer;

 // #####  #   #  ####   #####    #    ####          ###
 //   #    #   #  #   #  #       # #    #  #        #   #
 //   #    #   #  #   #  #      #   #   #  #            #
 //   #    #####  ####   ####   #   #   #  #          ##
 //   #    #   #  # #    #      #####   #  #         #
 //   #    #   #  #  #   #      #   #   #  #        #
 //   #    #   #  #   #  #####  #   #  ####         #####



bool Thread2_3_Forward_AbsLG_again1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread2_3_Forward_AbsLG_again(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)
     &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )

 );


mu bool Thread2_3_Backward_AbsLG_again(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(
  Thread2_3_Forward_AbsLG_again1(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G)
&

( false

  // initial configuration (init)
  |  (
        (exists
            Local   t_CL1,
            Local   t_CL2,
            Local   t_CL3,
            Global  t_G.
            (
                Thread3_3_Backward_AbsLG_again( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G )
              & t_G.v1 = 0
            )
        )
        &  ContextSwitch_2(s_pc2)
        &  ContextSwitch_3(s_pc3)
     )


//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc2,
           Local   t_CL2,
           Global  t_G.
           (    (   Thread2_3_Backward_AbsLG_again( s_pc1, s_CL1, t_pc2, t_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_2(s_pc2, t_pc2, s_CL2, t_CL2, s_G, t_G)      // Assignment related
                    & CopyVariables_ProgramInt_2(s_pc2, s_CL2, t_CL2, s_G, t_G)   //  Copy others global variable
                  )
                  | programInt3(2, s_pc2, t_pc2, s_CL2, t_CL2, s_G, t_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc2.
             (     Thread2_3_Backward_AbsLG_again( s_pc1, s_CL1, t_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_2(s_pc2, t_pc2,s_CL2,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread2_3_Backward_AbsLG_again;
//#reset Thread2_3_Forward_AbsLG_again;
#timer;

// ###   #  #  ###   ####   ##   ###          #
//  #    #  #  #  #  #     #  #  #  #        ##
//  #    ####  #  #  ###   #  #  #  #         #
//  #    #  #  ###   #     ####  #  #         #
//  #    #  #  # #   #     #  #  #  #         #
//  #    #  #  #  #  ####  #  #  ###         ###


bool Thread1_3_Forward_AbsLG_again1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread1_3_Forward_AbsLG_again(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)
     &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )

 );

mu bool Thread1_3_Backward_AbsLG_again(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(
  Thread1_3_Forward_AbsLG_again1( s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G )
&
( false

  // initial configuration (init)
  |  (
        (exists
            Local   t_CL1,
            Local   t_CL2,
            Local   t_CL3,
            Global  t_G.
            (
                Thread2_3_Backward_AbsLG_again( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G )
              & t_G.v1 = 0
            )
        )
        &  ContextSwitch_1(s_pc1)
        &  ContextSwitch_2(s_pc2)
     )

//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
         true
      & (exists                  // There exists an internal state that
           PrCount t_pc1,
           Local   t_CL1,
           Global t_G.
           (    (   Thread1_3_Backward_AbsLG_again( t_pc1, t_CL1, s_pc2, s_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_1(s_pc1, t_pc1, s_CL1, t_CL1, s_G, t_G)      // Assignment related
                    & CopyVariables_ProgramInt_1(s_pc1, s_CL1, t_CL1, s_G, t_G)   //  Copy others global variable
                  )
                  | programInt3(1, s_pc1, t_pc1, s_CL1, t_CL1, s_G, t_G )   // constrain
                )
           )
      )
    )

  | (
          true
       & (exists PrCount t_pc1.
             (     Thread1_3_Backward_AbsLG_again( t_pc1, s_CL1, s_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_1(s_pc1,t_pc1,s_CL1,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread1_3_Backward_AbsLG_again;
//#reset Thread1_3_Forward_AbsLG_again;
#timer;


// ####    ###   #   #  #   #  ####           ###
 // #   #  #   #  #   #  #   #   #  #         #   #
 // #   #  #   #  #   #  ##  #   #  #             #
 // ####   #   #  #   #  # # #   #  #           ##
 // # #    #   #  #   #  #  ##   #  #          #
 // #  #   #   #  #   #  #   #   #  #         #
 // #   #   ###    ###   #   #  ####          #####

// BACKWARD

// ###   #  #  ###   ####   ##   ###         ####
//  #    #  #  #  #  #     #  #  #  #           #
//  #    ####  #  #  ###   #  #  #  #         ##
//  #    #  #  ###   #     ####  #  #           #
//  #    #  #  # #   #     #  #  #  #        #  #
//  #    #  #  #  #  ####  #  #  ###          ##


bool Thread3_2_Forward_AbsLG_again1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread3_2_Forward_AbsLG_again(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)
     &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )

 );

mu bool Thread3_2_Backward_AbsLG_again(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(
  Thread3_2_Forward_AbsLG_again1(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G)
&
( false

  // initial configuration (init)
  | (exists
        Local   t_CL1,
        Local   t_CL2,
        Local   t_CL3,
        Global  t_G.
        (
            Thread1_3_Backward_AbsLG_again(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)
          & t_G.v1 = 0
        )
        & ContextSwitch_1(s_pc1)
        & ContextSwitch_3(s_pc3)
    )


//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc3,
           Local   t_CL3,
           Global  t_G.
           (    (
                  Thread3_2_Backward_AbsLG_again( s_pc1, s_CL1, s_pc2, s_CL2, t_pc3, t_CL3, t_G )
                )
               &(
                  ( programInt1_3(s_pc3, t_pc3, s_CL3, t_CL3, s_G, t_G)      // Assignment related
                    & CopyVariables_ProgramInt_3(s_pc3, s_CL3, t_CL3, s_G, t_G)   //  Copy others global variable
                  )
                  | programInt3(3, s_pc3, t_pc3, s_CL3, t_CL3, s_G, t_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc3.
             (
                Thread3_2_Backward_AbsLG_again( s_pc1, s_CL1, s_pc2, s_CL2, t_pc3, s_CL3, s_G )
                 & programInt2_3(s_pc3, t_pc3, s_CL3, s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread3_2_Backward_AbsLG_again;
//#reset Thread3_2_Forward_AbsLG_again;
#timer;

 // #####  #   #  ####   #####    #    ####          ###
 //   #    #   #  #   #  #       # #    #  #        #   #
 //   #    #   #  #   #  #      #   #   #  #            #
 //   #    #####  ####   ####   #   #   #  #          ##
 //   #    #   #  # #    #      #####   #  #         #
 //   #    #   #  #  #   #      #   #   #  #        #
 //   #    #   #  #   #  #####  #   #  ####         #####


bool Thread2_2_Forward_AbsLG_again1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread2_2_Forward_AbsLG_again(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)
     &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )

 );


mu bool Thread2_2_Backward_AbsLG_again(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(
  Thread2_2_Forward_AbsLG_again1( s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G )
&
( false

  // initial configuration (init)
  |  ( exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3,
          Global  t_G.
        (
             Thread3_2_Backward_AbsLG_again( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G )
          &  t_G.v1 = 0
        )
        &  ContextSwitch_2(s_pc2)
        &  ContextSwitch_3(s_pc3)
     )


//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc2,
           Local   t_CL2,
           Global  t_G.
           (    (   Thread2_2_Backward_AbsLG_again( s_pc1, s_CL1, t_pc2, t_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_2(s_pc2, t_pc2, s_CL2, t_CL2, s_G, t_G)      // Assignment related
                    & CopyVariables_ProgramInt_2(s_pc2, s_CL2, t_CL2, s_G, t_G)   //  Copy others global variable
                  )
                  | programInt3(2, s_pc2, t_pc2, s_CL2, t_CL2, s_G, t_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc2.
             (     Thread2_2_Backward_AbsLG_again( s_pc1, s_CL1, t_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_2(s_pc2, t_pc2,s_CL2,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread2_2_Backward_AbsLG_again;
//#reset Thread2_2_Forward_AbsLG_again;
#timer;



// ###   #  #  ###   ####   ##   ###          #
//  #    #  #  #  #  #     #  #  #  #        ##
//  #    ####  #  #  ###   #  #  #  #         #
//  #    #  #  ###   #     ####  #  #         #
//  #    #  #  # #   #     #  #  #  #         #
//  #    #  #  #  #  ####  #  #  ###         ###


bool Thread1_2_Forward_AbsLG_again1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread1_2_Forward_AbsLG_again(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)
     &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )

 );

mu bool Thread1_2_Backward_AbsLG_again(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(
    Thread1_2_Forward_AbsLG_again1( s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G )
&
( false

  // initial configuration (init)
  |  (exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3,
          Global  t_G.
        (
             Thread2_2_Backward_AbsLG_again( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G )
          &  t_G.v1 = 0
        )
        &  ContextSwitch_1(s_pc1)
        &  ContextSwitch_2(s_pc2)
     )

//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
         true
      & (exists                  // There exists an internal state that
           PrCount t_pc1,
           Local   t_CL1,
           Global t_G.
           (    (   Thread1_2_Backward_AbsLG_again( t_pc1, t_CL1, s_pc2, s_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_1(s_pc1, t_pc1, s_CL1, t_CL1, s_G, t_G)      // Assignment related
                    & CopyVariables_ProgramInt_1(s_pc1, s_CL1, t_CL1, s_G, t_G)   //  Copy others global variable
                  )
                  | programInt3(1, s_pc1, t_pc1, s_CL1, t_CL1, s_G, t_G )   // constrain
                )
           )
      )
    )

  | (
          true
       & (exists PrCount t_pc1.
             (     Thread1_2_Backward_AbsLG_again( t_pc1, s_CL1, s_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_1(s_pc1,t_pc1,s_CL1,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread1_2_Backward_AbsLG_again;
//#reset Thread1_2_Forward_AbsLG_again;
#timer;


// ####    ###   #   #  #   #  ####            #
// #   #  #   #  #   #  #   #   #  #          ##
// #   #  #   #  #   #  ##  #   #  #         # #
// ####   #   #  #   #  # # #   #  #           #
// # #    #   #  #   #  #  ##   #  #           #
// #  #   #   #  #   #  #   #   #  #           #
// #   #   ###    ###   #   #  ####          #####

// BACKWARD


// ###   #  #  ###   ####   ##   ###         ####
//  #    #  #  #  #  #     #  #  #  #           #
//  #    ####  #  #  ###   #  #  #  #         ##
//  #    #  #  ###   #     ####  #  #           #
//  #    #  #  # #   #     #  #  #  #        #  #
//  #    #  #  #  #  ####  #  #  ###          ##


bool Thread3_1_Forward_AbsLG_again1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread3_1_Forward_AbsLG_again(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)
     &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )

 );


mu bool Thread3_1_Backward_AbsLG_again(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(    Thread3_1_Forward_AbsLG_again1(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G)
&
( false

  // initial configuration (init)
  | (exists
        Local   t_CL1,
        Local   t_CL2,
        Local   t_CL3,
        Global  t_G.
        (
            Thread1_2_Backward_AbsLG_again(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)
          & t_G.v1 = 0
        )
        & ContextSwitch_1(s_pc1)
        & ContextSwitch_3(s_pc3)
    )


//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc3,
           Local   t_CL3,
           Global  t_G.
           (    (
                  Thread3_1_Backward_AbsLG_again( s_pc1, s_CL1, s_pc2, s_CL2, t_pc3, t_CL3, t_G )
                )
               &(
                  ( programInt1_3(s_pc3, t_pc3, s_CL3, t_CL3, s_G, t_G)      // Assignment related
                    & CopyVariables_ProgramInt_3(s_pc3, s_CL3, t_CL3, s_G, t_G)   //  Copy others global variable
                  )
                  | programInt3(3, s_pc3, t_pc3, s_CL3, t_CL3, s_G, t_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc3.
             (
                Thread3_1_Backward_AbsLG_again( s_pc1, s_CL1, s_pc2, s_CL2, t_pc3, s_CL3, s_G )
                 & programInt2_3(s_pc3, t_pc3, s_CL3, s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread3_1_Backward_AbsLG_again;
//#reset Thread3_1_Forward_AbsLG_again;
#timer;

 // #####  #   #  ####   #####    #    ####          ###
 //   #    #   #  #   #  #       # #    #  #        #   #
 //   #    #   #  #   #  #      #   #   #  #            #
 //   #    #####  ####   ####   #   #   #  #          ##
 //   #    #   #  # #    #      #####   #  #         #
 //   #    #   #  #  #   #      #   #   #  #        #
 //   #    #   #  #   #  #####  #   #  ####         #####


bool Thread2_1_Forward_AbsLG_again1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread2_1_Forward_AbsLG_again(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)
     &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )

 );


mu bool Thread2_1_Backward_AbsLG_again(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(    Thread2_1_Forward_AbsLG_again1( s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G )
&
( false

  // initial configuration (init)
  |  ( exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3,
          Global  t_G.
        (
             Thread3_1_Backward_AbsLG_again( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G )
          &  t_G.v1 = 0
        )
        &  ContextSwitch_2(s_pc2)
        &  ContextSwitch_3(s_pc3)
     )


//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc2,
           Local   t_CL2,
           Global  t_G.
           (    (   Thread2_1_Backward_AbsLG_again( s_pc1, s_CL1, t_pc2, t_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_2(s_pc2, t_pc2, s_CL2, t_CL2, s_G, t_G)      // Assignment related
                    & CopyVariables_ProgramInt_2(s_pc2, s_CL2, t_CL2, s_G, t_G)   //  Copy others global variable
                  )
                  | programInt3(2, s_pc2, t_pc2, s_CL2, t_CL2, s_G, t_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc2.
             (     Thread2_1_Backward_AbsLG_again( s_pc1, s_CL1, t_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_2(s_pc2, t_pc2,s_CL2,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread2_1_Backward_AbsLG_again;
//#reset Thread2_1_Forward_AbsLG_again;
#timer;



// ###   #  #  ###   ####   ##   ###          #
//  #    #  #  #  #  #     #  #  #  #        ##
//  #    ####  #  #  ###   #  #  #  #         #
//  #    #  #  ###   #     ####  #  #         #
//  #    #  #  # #   #     #  #  #  #         #
//  #    #  #  #  #  ####  #  #  ###         ###


bool Thread1_1_Forward_AbsLG_again1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread1_1_Forward_AbsLG_again(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)
     &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )

 );

mu bool Thread1_1_Backward_AbsLG_again(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(   Thread1_1_Forward_AbsLG_again1( s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G )
&
( false

  // initial configuration (init)
  |  (exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3,
          Global  t_G.
        (
            Thread2_1_Backward_AbsLG_again( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G )
          &  t_G.v1 = 0
        )
        &  ContextSwitch_1(s_pc1)
        &  ContextSwitch_2(s_pc2)
     )

//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
         true
      & (exists                  // There exists an internal state that
           PrCount t_pc1,
           Local   t_CL1,
           Global t_G.
           (    (   Thread1_1_Backward_AbsLG_again( t_pc1, t_CL1, s_pc2, s_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_1(s_pc1, t_pc1, s_CL1, t_CL1, s_G, t_G)      // Assignment related
                    & CopyVariables_ProgramInt_1(s_pc1, s_CL1, t_CL1, s_G, t_G)   //  Copy others global variable
                  )
                  | programInt3(1, s_pc1, t_pc1, s_CL1, t_CL1, s_G, t_G )   // constrain
                )
           )
      )
    )

  | (

          true
       & (exists PrCount t_pc1.
             (     Thread1_1_Backward_AbsLG_again( t_pc1, s_CL1, s_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_1(s_pc1,t_pc1,s_CL1,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread1_1_Backward_AbsLG_again;
//#reset Thread1_1_Forward_AbsLG_again;
#timer;


// ####    ###   #   #  #   #  ####            #
// #   #  #   #  #   #  #   #   #  #          # #
// #   #  #   #  #   #  ##  #   #  #         #   #
// ####   #   #  #   #  # # #   #  #         #   #
// # #    #   #  #   #  #  ##   #  #         #   #
// #  #   #   #  #   #  #   #   #  #          # #
// #   #   ###    ###   #   #  ####            #

// BACKWARD

// ###   #  #  ###   ####   ##   ###         ####
//  #    #  #  #  #  #     #  #  #  #           #
//  #    ####  #  #  ###   #  #  #  #         ##
//  #    #  #  ###   #     ####  #  #           #
//  #    #  #  # #   #     #  #  #  #        #  #
//  #    #  #  #  #  ####  #  #  ###          ##


bool Thread3_0_Forward_AbsLG_again1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread3_0_Forward_AbsLG_again(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)
     &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )

 );


mu bool Thread3_0_Backward_AbsLG_again(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(
  Thread3_0_Forward_AbsLG_again1(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G)
&
( false

  // initial configuration (init)
  | (exists
        Local   t_CL1,
        Local   t_CL2,
        Local   t_CL3,
        Global  t_G.
        (
            Thread1_1_Backward_AbsLG_again(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)
          & t_G.v1 = 0
        )
        & ContextSwitch_1(s_pc1)
        & ContextSwitch_3(s_pc3)
    )


//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc3,
           Local   t_CL3,
           Global  t_G.
           (    (
                  Thread3_0_Backward_AbsLG_again( s_pc1, s_CL1, s_pc2, s_CL2, t_pc3, t_CL3, t_G )
                )
               &(
                  ( programInt1_3(s_pc3, t_pc3, s_CL3, t_CL3, s_G, t_G)      // Assignment related
                    & CopyVariables_ProgramInt_3(s_pc3, s_CL3, t_CL3, s_G, t_G)   //  Copy others global variable
                  )
                  | programInt3(3, s_pc3, t_pc3, s_CL3, t_CL3, s_G, t_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc3.
             (
                Thread3_0_Backward_AbsLG_again( s_pc1, s_CL1, s_pc2, s_CL2, t_pc3, s_CL3, s_G )
                 & programInt2_3(s_pc3, t_pc3, s_CL3, s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread3_0_Backward_AbsLG_again;
//#reset Thread3_0_Forward_AbsLG_again;
#timer;

 // #####  #   #  ####   #####    #    ####          ###
 //   #    #   #  #   #  #       # #    #  #        #   #
 //   #    #   #  #   #  #      #   #   #  #            #
 //   #    #####  ####   ####   #   #   #  #          ##
 //   #    #   #  # #    #      #####   #  #         #
 //   #    #   #  #  #   #      #   #   #  #        #
 //   #    #   #  #   #  #####  #   #  ####         #####


bool Thread2_0_Forward_AbsLG_again1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread2_0_Forward_AbsLG_again(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)
     &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )

 );

mu bool Thread2_0_Backward_AbsLG_again(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(
   Thread2_0_Forward_AbsLG_again1( s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G )
&
( false

  // initial configuration (init)
  |  ( exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3,
          Global  t_G.
        (
             Thread3_0_Backward_AbsLG_again( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G )
          &  t_G.v1 = 0
        )
        &  ContextSwitch_2(s_pc2)
        &  ContextSwitch_3(s_pc3)
     )


//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc2,
           Local   t_CL2,
           Global  t_G.
           (    (   Thread2_0_Backward_AbsLG_again( s_pc1, s_CL1, t_pc2, t_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_2(s_pc2, t_pc2, s_CL2, t_CL2, s_G, t_G)      // Assignment related
                    & CopyVariables_ProgramInt_2(s_pc2, s_CL2, t_CL2, s_G, t_G)   //  Copy others global variable
                  )
                  | programInt3(2, s_pc2, t_pc2, s_CL2, t_CL2, s_G, t_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc2.
             (     Thread2_0_Backward_AbsLG_again( s_pc1, s_CL1, t_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_2(s_pc2, t_pc2,s_CL2,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread2_0_Backward_AbsLG_again;
//#reset Thread2_0_Forward_AbsLG_again;
#timer;



// ###   #  #  ###   ####   ##   ###          #
//  #    #  #  #  #  #     #  #  #  #        ##
//  #    ####  #  #  ###   #  #  #  #         #
//  #    #  #  ###   #     ####  #  #         #
//  #    #  #  # #   #     #  #  #  #         #
//  #    #  #  #  #  ####  #  #  ###         ###

bool Thread1_0_Forward_AbsLG_again1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread1_0_Forward_AbsLG_again(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)
     &  FakeOrderingLocalGlobal( s_pc1, t_CL1, s_CL1, s_pc2, t_CL2, s_CL2, s_pc3, t_CL3, s_CL3, t_G, s_G )

 );

mu bool Thread1_0_Backward_AbsLG_again(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(  Thread1_0_Forward_AbsLG_again1( s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G )
&
( false

  // initial configuration (init)
  |  (exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3,
          Global  t_G.
        (
             Thread2_0_Backward_AbsLG_again( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G )
          &  t_G.v1 = 0
        )
        &  ContextSwitch_1(s_pc1)
        &  ContextSwitch_2(s_pc2)
     )

//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
         true
      & (exists                  // There exists an internal state that
           PrCount t_pc1,
           Local   t_CL1,
           Global t_G.
           (    (   Thread1_0_Backward_AbsLG_again( t_pc1, t_CL1, s_pc2, s_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_1(s_pc1, t_pc1, s_CL1, t_CL1, s_G, t_G)      // Assignment related
                    & CopyVariables_ProgramInt_1(s_pc1, s_CL1, t_CL1, s_G, t_G)   //  Copy others global variable
                  )
                  | programInt3(1, s_pc1, t_pc1, s_CL1, t_CL1, s_G, t_G )   // constrain
                )
           )
      )
    )

  | (

          true
       & (exists PrCount t_pc1.
             (     Thread1_0_Backward_AbsLG_again( t_pc1, s_CL1, s_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_1(s_pc1,t_pc1,s_CL1,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread1_0_Backward_AbsLG_again;
//#reset Thread1_0_Forward_AbsLG_again;
#timer;





//                                                                  ###
// #         #     #   #   ######  #####                           #   #
// #         #     #   #   #       #    #                              #
// #        ###     # #    #       #    #                             #
// #        # #      #     ####    #####                             #
// #       #####     #     #       #  #                             #
// #       #   #     #     #       #   #                           #
// #####  ##   ##    #     ######  #    #                          #####


// ####    ###   #   #  #   #  ####            #
// #   #  #   #  #   #  #   #   #  #          # #
// #   #  #   #  #   #  ##  #   #  #         #   #
// ####   #   #  #   #  # # #   #  #         #   #
// # #    #   #  #   #  #  ##   #  #         #   #
// #  #   #   #  #   #  #   #   #  #          # #
// #   #   ###    ###   #   #  ####            #

// Forward abstraction

// ###   #  #  ###   ####   ##   ###          #
//  #    #  #  #  #  #     #  #  #  #        ##
//  #    ####  #  #  ###   #  #  #  #         #
//  #    #  #  ###   #     ####  #  #         #
//  #    #  #  # #   #     #  #  #  #         #
//  #    #  #  #  #  ####  #  #  ###         ###

bool Thread1_0_Backward_AbsLG1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread1_0_Backward_AbsLG(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)

 );

mu bool Thread1_0_Forward_AbsLocal(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(
  Thread1_0_Backward_AbsLG1(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G)
&
( false

  // initial configuration (init)
  |  (
           initPC(s_pc1)              // Initial PC
         & initPC(s_pc2)              // Initial PC
         & initPC(s_pc3)              // Initial PC
         & GlobalInit(s_G)
     )

//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
         true
      & (exists                  // There exists an internal state that
           PrCount t_pc1,
           Local   t_CL1,
           Global t_G.
           (    (   Thread1_0_Forward_AbsLocal( t_pc1, t_CL1, s_pc2, s_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  (
                    programInt1_1(t_pc1,s_pc1,t_CL1,s_CL1,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_1(t_pc1,t_CL1,s_CL1,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(1, t_pc1, s_pc1, t_CL1, s_CL1, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (
          true
       & (exists PrCount t_pc1.
             (     Thread1_0_Forward_AbsLocal( t_pc1, s_CL1, s_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_1(t_pc1,s_pc1,s_CL1,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread1_0_Forward_AbsLocal;
//#reset Thread1_0_Backward_AbsLG;
#timer;


 // #####  #   #  ####   #####    #    ####          ###
 //   #    #   #  #   #  #       # #    #  #        #   #
 //   #    #   #  #   #  #      #   #   #  #            #
 //   #    #####  ####   ####   #   #   #  #          ##
 //   #    #   #  # #    #      #####   #  #         #
 //   #    #   #  #  #   #      #   #   #  #        #
 //   #    #   #  #   #  #####  #   #  ####         #####

bool Thread2_0_Backward_AbsLG1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread2_0_Backward_AbsLG(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)

 );

mu bool Thread2_0_Forward_AbsLocal(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(
  Thread2_0_Backward_AbsLG1( s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G )
&
( false

  // initial configuration (init)
  |  (  (exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3.
          (
                 Thread1_0_Forward_AbsLocal( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G )
          )
        )
              &  s_G.v1 = 0
        &  ContextSwitch_1(s_pc1)
     )


//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc2,
           Local   t_CL2,
           Global  t_G.
           (    (   Thread2_0_Forward_AbsLocal( s_pc1, s_CL1, t_pc2, t_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_2(t_pc2,s_pc2,t_CL2,s_CL2,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_2(t_pc2,t_CL2,s_CL2,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(2, t_pc2, s_pc2, t_CL2, s_CL2, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc2.
             (     Thread2_0_Forward_AbsLocal( s_pc1, s_CL1, t_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_2(t_pc2,s_pc2,s_CL2,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread2_0_Forward_AbsLocal;
//#reset Thread2_0_Backward_AbsLG;
#timer;



// ###   #  #  ###   ####   ##   ###         ####
//  #    #  #  #  #  #     #  #  #  #           #
//  #    ####  #  #  ###   #  #  #  #         ##
//  #    #  #  ###   #     ####  #  #           #
//  #    #  #  # #   #     #  #  #  #        #  #
//  #    #  #  #  #  ####  #  #  ###          ##

bool Thread3_0_Backward_AbsLG1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread3_0_Backward_AbsLG(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)

 );

mu bool Thread3_0_Forward_AbsLocal(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(
  Thread3_0_Backward_AbsLG1( s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G )
&
( false

  // initial configuration (init)
  |  (
        (exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3.
          (
                 Thread2_0_Forward_AbsLocal( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G )
          )
        )
              &  s_G.v1 = 0
        &  ContextSwitch_2(s_pc2)
     )


//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc3,
           Local   t_CL3,
           Global  t_G.
           (    (   Thread3_0_Forward_AbsLocal( s_pc1, s_CL1, s_pc2, s_CL2, t_pc3, t_CL3, t_G )
                )
               &(
                  ( programInt1_3(t_pc3,s_pc3,t_CL3,s_CL3,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_3(t_pc3,t_CL3,s_CL3,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(3, t_pc3, s_pc3, t_CL3, s_CL3, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc3.
             (     Thread3_0_Forward_AbsLocal( s_pc1, s_CL1, s_pc2, s_CL2,t_pc3, s_CL3, s_G )
                 & programInt2_3(t_pc3,s_pc3,s_CL3,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread3_0_Forward_AbsLocal;
//#reset Thread3_0_Backward_AbsLG;
#timer;


// ####    ###   #   #  #   #  ####                   #
// #   #  #   #  #   #  #   #   #  #                 ##
// #   #  #   #  #   #  ##  #   #  #                # #
// ####   #   #  #   #  # # #   #  #                  #
// # #    #   #  #   #  #  ##   #  #                  #
// #  #   #   #  #   #  #   #   #  #                  #
// #   #   ###    ###   #   #  ####                 #####

// FORWARD ABSTRACTION

// ###   #  #  ###   ####   ##   ###          #
//  #    #  #  #  #  #     #  #  #  #        ##
//  #    ####  #  #  ###   #  #  #  #         #
//  #    #  #  ###   #     ####  #  #         #
//  #    #  #  # #   #     #  #  #  #         #
//  #    #  #  #  #  ####  #  #  ###         ###


bool Thread1_1_Backward_AbsLG1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread1_1_Backward_AbsLG(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)

 );

mu bool Thread1_1_Forward_AbsLocal(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(  Thread1_1_Backward_AbsLG1( s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G )
&
( false

  // initial configuration (init)
  |  (
        (exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3,
          Global  t_G.
          (
                 Thread3_0_Forward_AbsLocal( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G )
              &  t_G.v1 = 0
          )
        )
        &  ContextSwitch_3(s_pc3)
     )

//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
         true
      & (exists                  // There exists an internal state that
           PrCount t_pc1,
           Local   t_CL1,
           Global t_G.
           (    (   Thread1_1_Forward_AbsLocal( t_pc1, t_CL1, s_pc2, s_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_1(t_pc1,s_pc1,t_CL1,s_CL1,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_1(t_pc1,t_CL1,s_CL1,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(1, t_pc1, s_pc1, t_CL1, s_CL1, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc1.
             (     Thread1_1_Forward_AbsLocal( t_pc1, s_CL1, s_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_1(t_pc1,s_pc1,s_CL1,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread1_1_Forward_AbsLocal;
//#reset Thread1_1_Backward_AbsLG;
#timer;

 // #####  #   #  ####   #####    #    ####          ###
 //   #    #   #  #   #  #       # #    #  #        #   #
 //   #    #   #  #   #  #      #   #   #  #            #
 //   #    #####  ####   ####   #   #   #  #          ##
 //   #    #   #  # #    #      #####   #  #         #
 //   #    #   #  #  #   #      #   #   #  #        #
 //   #    #   #  #   #  #####  #   #  ####         #####


bool Thread2_1_Backward_AbsLG1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread2_1_Backward_AbsLG(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)

 );

mu bool Thread2_1_Forward_AbsLocal(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(  Thread2_1_Backward_AbsLG1( s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G )
&
( false

  // initial configuration (init)
  |  (
        (exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3.
          (
                 Thread1_1_Forward_AbsLocal( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G )
          )
        )
              &  s_G.v1 = 0
        &  ContextSwitch_1(s_pc1)
     )

//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc2,
           Local   t_CL2,
           Global  t_G.
           (    (
                    Thread2_1_Forward_AbsLocal( s_pc1, s_CL1, t_pc2, t_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_2(t_pc2,s_pc2,t_CL2,s_CL2,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_2(t_pc2,t_CL2,s_CL2,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(2, t_pc2, s_pc2, t_CL2, s_CL2, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc2.
             (
                  Thread2_1_Forward_AbsLocal( s_pc1, s_CL1, t_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_2(t_pc2,s_pc2,s_CL2,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread2_1_Forward_AbsLocal;
//#reset Thread2_1_Backward_AbsLG;
#timer;

// ###   #  #  ###   ####   ##   ###         ####
//  #    #  #  #  #  #     #  #  #  #           #
//  #    ####  #  #  ###   #  #  #  #         ##
//  #    #  #  ###   #     ####  #  #           #
//  #    #  #  # #   #     #  #  #  #        #  #
//  #    #  #  #  #  ####  #  #  ###          ##

bool Thread3_1_Backward_AbsLG1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread3_1_Backward_AbsLG(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)

 );

mu bool Thread3_1_Forward_AbsLocal(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                      // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(
  Thread3_1_Backward_AbsLG1( s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G )
&
( false
  // initial configuration (init)
  |  (
        (exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3.
          (
                 Thread2_1_Forward_AbsLocal( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G )
          )
        )
              &  s_G.v1 = 0
        &  ContextSwitch_2(s_pc2)
     )

//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc3,
           Local   t_CL3,
           Global  t_G.
           (    (
                   Thread3_1_Forward_AbsLocal( s_pc1, s_CL1, s_pc2, s_CL2, t_pc3, t_CL3, t_G )
                )
               &(
                  ( programInt1_3(t_pc3,s_pc3,t_CL3,s_CL3,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_3(t_pc3,t_CL3,s_CL3,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(3, t_pc3, s_pc3, t_CL3, s_CL3, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc3.
             (
              Thread3_1_Forward_AbsLocal( s_pc1, s_CL1, s_pc2, s_CL2,t_pc3, s_CL3, s_G )
                 & programInt2_3(t_pc3,s_pc3,s_CL3,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread3_1_Forward_AbsLocal;
//#reset Thread3_1_Backward_AbsLG;
#timer;



// ####    ###   #   #  #   #  ####           ###
// #   #  #   #  #   #  #   #   #  #         #   #
// #   #  #   #  #   #  ##  #   #  #             #
// ####   #   #  #   #  # # #   #  #           ##
// # #    #   #  #   #  #  ##   #  #          #
// #  #   #   #  #   #  #   #   #  #         #
// #   #   ###    ###   #   #  ####          #####

// FORWARD ABSTRACTION


// ###   #  #  ###   ####   ##   ###          #
//  #    #  #  #  #  #     #  #  #  #        ##
//  #    ####  #  #  ###   #  #  #  #         #
//  #    #  #  ###   #     ####  #  #         #
//  #    #  #  # #   #     #  #  #  #         #
//  #    #  #  #  #  ####  #  #  ###         ###


bool Thread1_2_Backward_AbsLG1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread1_2_Backward_AbsLG(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)

 );


mu bool Thread1_2_Forward_AbsLocal(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
( Thread1_2_Backward_AbsLG1( s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G )
&
( false

  // initial configuration (init)
  |  (
        (exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3,
          Global  t_G.
          (
                 Thread3_1_Forward_AbsLocal( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G )
              &  t_G.v1 = 0
          )
        )
        &  ContextSwitch_3(s_pc3)
     )

//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
         true
      & (exists                  // There exists an internal state that
           PrCount t_pc1,
           Local   t_CL1,
           Global t_G.
           (    (   Thread1_2_Forward_AbsLocal( t_pc1, t_CL1, s_pc2, s_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_1(t_pc1,s_pc1,t_CL1,s_CL1,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_1(t_pc1,t_CL1,s_CL1,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(1, t_pc1, s_pc1, t_CL1, s_CL1, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc1.
             (     Thread1_2_Forward_AbsLocal( t_pc1, s_CL1, s_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_1(t_pc1,s_pc1,s_CL1,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread1_2_Forward_AbsLocal;
//#reset Thread1_2_Backward_AbsLG;
#timer;

 // #####  #   #  ####   #####    #    ####          ###
 //   #    #   #  #   #  #       # #    #  #        #   #
 //   #    #   #  #   #  #      #   #   #  #            #
 //   #    #####  ####   ####   #   #   #  #          ##
 //   #    #   #  # #    #      #####   #  #         #
 //   #    #   #  #  #   #      #   #   #  #        #
 //   #    #   #  #   #  #####  #   #  ####         #####

bool Thread2_2_Backward_AbsLG1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread2_2_Backward_AbsLG(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)

 );

mu bool Thread2_2_Forward_AbsLocal(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(  Thread2_2_Backward_AbsLG1( s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G )
&
( false

  // initial configuration (init)
  |  (
        (exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3.
          (
                 Thread1_2_Forward_AbsLocal( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G )
          )
        )
        &  s_G.v1 = 0
        &  ContextSwitch_1(s_pc1)
     )

//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc2,
           Local   t_CL2,
           Global  t_G.
           (    (   Thread2_2_Forward_AbsLocal( s_pc1, s_CL1, t_pc2, t_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_2(t_pc2,s_pc2,t_CL2,s_CL2,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_2(t_pc2,t_CL2,s_CL2,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(2, t_pc2, s_pc2, t_CL2, s_CL2, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc2.
             (     Thread2_2_Forward_AbsLocal( s_pc1, s_CL1, t_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_2(t_pc2,s_pc2,s_CL2,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread2_2_Forward_AbsLocal;
//#reset Thread2_2_Backward_AbsLG;
#timer;

// ###   #  #  ###   ####   ##   ###         ####
//  #    #  #  #  #  #     #  #  #  #           #
//  #    ####  #  #  ###   #  #  #  #         ##
//  #    #  #  ###   #     ####  #  #           #
//  #    #  #  # #   #     #  #  #  #        #  #
//  #    #  #  #  #  ####  #  #  ###          ##


bool Thread3_2_Backward_AbsLG1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread3_2_Backward_AbsLG(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)

 );

mu bool Thread3_2_Forward_AbsLocal(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                      // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(  Thread3_2_Backward_AbsLG1( s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G )
&
( false
  // initial configuration (init)
  |  (
        (exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3.
          (
                 Thread2_2_Forward_AbsLocal( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G )
          )
        )
        &  s_G.v1 = 0
        &  ContextSwitch_2(s_pc2)
     )

//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc3,
           Local   t_CL3,
           Global  t_G.
           (    (   Thread3_2_Forward_AbsLocal( s_pc1, s_CL1, s_pc2, s_CL2, t_pc3, t_CL3, t_G )
                )
               &(
                  ( programInt1_3(t_pc3,s_pc3,t_CL3,s_CL3,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_3(t_pc3,t_CL3,s_CL3,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(3, t_pc3, s_pc3, t_CL3, s_CL3, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc3.
             (     Thread3_2_Forward_AbsLocal( s_pc1, s_CL1, s_pc2, s_CL2,t_pc3, s_CL3, s_G )
                 & programInt2_3(t_pc3,s_pc3,s_CL3,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread3_2_Forward_AbsLocal;
//#reset Thread3_2_Backward_AbsLG;
#timer;


// ####    ###   #   #  #   #  ####          #####
// #   #  #   #  #   #  #   #   #  #             #
// #   #  #   #  #   #  ##  #   #  #            #
// ####   #   #  #   #  # # #   #  #           ##
// # #    #   #  #   #  #  ##   #  #             #
// #  #   #   #  #   #  #   #   #  #         #   #
// #   #   ###    ###   #   #  ####           ###

// FORWARD ABSTRACTION

// ###   #  #  ###   ####   ##   ###          #
//  #    #  #  #  #  #     #  #  #  #        ##
//  #    ####  #  #  ###   #  #  #  #         #
//  #    #  #  ###   #     ####  #  #         #
//  #    #  #  # #   #     #  #  #  #         #
//  #    #  #  #  #  ####  #  #  ###         ###

bool Thread1_3_Backward_AbsLG1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
( ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread1_3_Backward_AbsLG(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)

 )
 );

mu bool Thread1_3_Forward_AbsLocal(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(  Thread1_3_Backward_AbsLG1( s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G )
&
( false

  // initial configuration (init)
  |  (
        (exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3,
          Global  t_G.
          (
                 Thread3_2_Forward_AbsLocal( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G )
              &  t_G.v1 = 0
          )
        )
        &  ContextSwitch_3(s_pc3)
     )

//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
         true
      & (exists                  // There exists an internal state that
           PrCount t_pc1,
           Local   t_CL1,
           Global t_G.
           (    (   Thread1_3_Forward_AbsLocal( t_pc1, t_CL1, s_pc2, s_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_1(t_pc1,s_pc1,t_CL1,s_CL1,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_1(t_pc1,t_CL1,s_CL1,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(1, t_pc1, s_pc1, t_CL1, s_CL1, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc1.
             (     Thread1_3_Forward_AbsLocal( t_pc1, s_CL1, s_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_1(t_pc1,s_pc1,s_CL1,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread1_3_Forward_AbsLocal;
//#reset Thread1_3_Backward_AbsLG;
#timer;

 // #####  #   #  ####   #####    #    ####          ###
 //   #    #   #  #   #  #       # #    #  #        #   #
 //   #    #   #  #   #  #      #   #   #  #            #
 //   #    #####  ####   ####   #   #   #  #          ##
 //   #    #   #  # #    #      #####   #  #         #
 //   #    #   #  #  #   #      #   #   #  #        #
 //   #    #   #  #   #  #####  #   #  ####         #####


bool Thread2_3_Backward_AbsLG1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread2_3_Backward_AbsLG(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)

 );

mu bool Thread2_3_Forward_AbsLocal(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(  Thread2_3_Backward_AbsLG1( s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G )
&
( false

  // initial configuration (init)
  |  (
        (exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3.
          (
                 Thread1_3_Forward_AbsLocal( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G )
          )
        )
              &  s_G.v1 = 0
        &  ContextSwitch_1(s_pc1)
     )

//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc2,
           Local   t_CL2,
           Global  t_G.
           (    (   Thread2_3_Forward_AbsLocal( s_pc1, s_CL1, t_pc2, t_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_2(t_pc2,s_pc2,t_CL2,s_CL2,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_2(t_pc2,t_CL2,s_CL2,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(2, t_pc2, s_pc2, t_CL2, s_CL2, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc2.
             (     Thread2_3_Forward_AbsLocal( s_pc1, s_CL1, t_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_2(t_pc2,s_pc2,s_CL2,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread2_3_Forward_AbsLocal;
//#reset Thread2_3_Backward_AbsLG;
#timer;

// ###   #  #  ###   ####   ##   ###         ####
//  #    #  #  #  #  #     #  #  #  #           #
//  #    ####  #  #  ###   #  #  #  #         ##
//  #    #  #  ###   #     ####  #  #           #
//  #    #  #  # #   #     #  #  #  #        #  #
//  #    #  #  #  #  ####  #  #  ###          ##


bool Thread3_3_Backward_AbsLG1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread3_3_Backward_AbsLG(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)

 );

mu bool Thread3_3_Forward_AbsLocal(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                      // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(  Thread3_3_Backward_AbsLG1( s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G )
&
( false
  // initial configuration (init)
  |  (
        (exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3.
          (
                 Thread2_3_Forward_AbsLocal( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G )
          )
        )
              &  s_G.v1 = 0
        &  ContextSwitch_2(s_pc2)
     )

//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc3,
           Local   t_CL3,
           Global  t_G.
           (    (   Thread3_3_Forward_AbsLocal( s_pc1, s_CL1, s_pc2, s_CL2, t_pc3, t_CL3, t_G )
                )
               &(
                  ( programInt1_3(t_pc3,s_pc3,t_CL3,s_CL3,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_3(t_pc3,t_CL3,s_CL3,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(3, t_pc3, s_pc3, t_CL3, s_CL3, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc3.
             (     Thread3_3_Forward_AbsLocal( s_pc1, s_CL1, s_pc2, s_CL2,t_pc3, s_CL3, s_G )
                 & programInt2_3(t_pc3,s_pc3,s_CL3,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread3_3_Forward_AbsLocal;
//#reset Thread3_3_Backward_AbsLG;
#timer;

// ####    ###   #   #  #   #  ####          #####
// #   #  #   #  #   #  #   #   #  #             #
// #   #  #   #  #   #  ##  #   #  #            #
// ####   #   #  #   #  # # #   #  #           ##
// # #    #   #  #   #  #  ##   #  #             #
// #  #   #   #  #   #  #   #   #  #         #   #
// #   #   ###    ###   #   #  ####           ###

// BACKWARD

// ###   #  #  ###   ####   ##   ###         ####
//  #    #  #  #  #  #     #  #  #  #           #
//  #    ####  #  #  ###   #  #  #  #         ##
//  #    #  #  ###   #     ####  #  #           #
//  #    #  #  # #   #     #  #  #  #        #  #
//  #    #  #  #  #  ####  #  #  ###          ##

bool Thread3_3_Forward_AbsLocal1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread3_3_Forward_AbsLocal(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G)

 );

mu bool Thread3_3_Backward_AbsLocal(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(  Thread3_3_Forward_AbsLocal1(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G)
&
( false

  // initial configuration (init)
  | (
      // target
      (
          target(1, s_pc1)
        | target(2, s_pc2)
        | target(3, s_pc3)
      )
    )


//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc3,
           Local   t_CL3,
           Global  t_G.
           (    (
                  Thread3_3_Backward_AbsLocal( s_pc1, s_CL1, s_pc2, s_CL2, t_pc3, t_CL3, t_G )
                )
               &(
                  ( programInt1_3(s_pc3, t_pc3, s_CL3, t_CL3, s_G, t_G)      // Assignment related
                    & CopyVariables_ProgramInt_3(s_pc3, s_CL3, t_CL3, s_G, t_G)   //  Copy others global variable
                  )
                  | programInt3(3, s_pc3, t_pc3, s_CL3, t_CL3, s_G, t_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc3.
             (
                Thread3_3_Backward_AbsLocal( s_pc1, s_CL1, s_pc2, s_CL2, t_pc3, s_CL3, s_G )
                 & programInt2_3(s_pc3, t_pc3, s_CL3, s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread3_3_Backward_AbsLocal;
//#reset Thread3_3_Forward_AbsLocal;
#timer;

 // #####  #   #  ####   #####    #    ####          ###
 //   #    #   #  #   #  #       # #    #  #        #   #
 //   #    #   #  #   #  #      #   #   #  #            #
 //   #    #####  ####   ####   #   #   #  #          ##
 //   #    #   #  # #    #      #####   #  #         #
 //   #    #   #  #  #   #      #   #   #  #        #
 //   #    #   #  #   #  #####  #   #  ####         #####

bool Thread2_3_Forward_AbsLocal1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread2_3_Forward_AbsLocal(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G)

 );

mu bool Thread2_3_Backward_AbsLocal(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(  Thread2_3_Forward_AbsLocal1(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G)
&
( false

  // initial configuration (init)
  |  (
        (exists
            Local   t_CL1,
            Local   t_CL2,
            Local   t_CL3.
            (
                Thread3_3_Backward_AbsLocal( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G )
            )
        )
              & s_G.v1 = 0
        &  ContextSwitch_2(s_pc2)
        &  ContextSwitch_3(s_pc3)
     )


//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc2,
           Local   t_CL2,
           Global  t_G.
           (    (   Thread2_3_Backward_AbsLocal( s_pc1, s_CL1, t_pc2, t_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_2(s_pc2, t_pc2, s_CL2, t_CL2, s_G, t_G)      // Assignment related
                    & CopyVariables_ProgramInt_2(s_pc2, s_CL2, t_CL2, s_G, t_G)   //  Copy others global variable
                  )
                  | programInt3(2, s_pc2, t_pc2, s_CL2, t_CL2, s_G, t_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc2.
             (     Thread2_3_Backward_AbsLocal( s_pc1, s_CL1, t_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_2(s_pc2, t_pc2,s_CL2,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread2_3_Backward_AbsLocal;
//#reset Thread2_3_Forward_AbsLocal;
#timer;

// ###   #  #  ###   ####   ##   ###          #
//  #    #  #  #  #  #     #  #  #  #        ##
//  #    ####  #  #  ###   #  #  #  #         #
//  #    #  #  ###   #     ####  #  #         #
//  #    #  #  # #   #     #  #  #  #         #
//  #    #  #  #  #  ####  #  #  ###         ###


bool Thread1_3_Forward_AbsLocal1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread1_3_Forward_AbsLocal(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G)

 );

mu bool Thread1_3_Backward_AbsLocal(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(  Thread1_3_Forward_AbsLocal1( s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G )
&
( false

  // initial configuration (init)
  |  (
        (exists
            Local   t_CL1,
            Local   t_CL2,
            Local   t_CL3.
            (
                Thread2_3_Backward_AbsLocal( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G )
            )
        )
              & s_G.v1 = 0
        &  ContextSwitch_1(s_pc1)
        &  ContextSwitch_2(s_pc2)
     )

//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
         true
      & (exists                  // There exists an internal state that
           PrCount t_pc1,
           Local   t_CL1,
           Global t_G.
           (    (   Thread1_3_Backward_AbsLocal( t_pc1, t_CL1, s_pc2, s_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_1(s_pc1, t_pc1, s_CL1, t_CL1, s_G, t_G)      // Assignment related
                    & CopyVariables_ProgramInt_1(s_pc1, s_CL1, t_CL1, s_G, t_G)   //  Copy others global variable
                  )
                  | programInt3(1, s_pc1, t_pc1, s_CL1, t_CL1, s_G, t_G )   // constrain
                )
           )
      )
    )

  | (
          true
       & (exists PrCount t_pc1.
             (     Thread1_3_Backward_AbsLocal( t_pc1, s_CL1, s_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_1(s_pc1,t_pc1,s_CL1,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread1_3_Backward_AbsLocal;
//#reset Thread1_3_Forward_AbsLocal;
#timer;


// ####    ###   #   #  #   #  ####           ###
 // #   #  #   #  #   #  #   #   #  #         #   #
 // #   #  #   #  #   #  ##  #   #  #             #
 // ####   #   #  #   #  # # #   #  #           ##
 // # #    #   #  #   #  #  ##   #  #          #
 // #  #   #   #  #   #  #   #   #  #         #
 // #   #   ###    ###   #   #  ####          #####

// BACKWARD

// ###   #  #  ###   ####   ##   ###         ####
//  #    #  #  #  #  #     #  #  #  #           #
//  #    ####  #  #  ###   #  #  #  #         ##
//  #    #  #  ###   #     ####  #  #           #
//  #    #  #  # #   #     #  #  #  #        #  #
//  #    #  #  #  #  ####  #  #  ###          ##

bool Thread3_2_Forward_AbsLocal1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread3_2_Forward_AbsLocal(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)

 );


mu bool Thread3_2_Backward_AbsLocal(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(  Thread3_2_Forward_AbsLocal1(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G)
&
( false

  // initial configuration (init)
  | (exists
        Local   t_CL1,
        Local   t_CL2,
        Local   t_CL3,
        Global  t_G.
        (
            Thread1_3_Backward_AbsLocal(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)
          & t_G.v1 = 0
        )
        & ContextSwitch_1(s_pc1)
        & ContextSwitch_3(s_pc3)
    )


//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc3,
           Local   t_CL3,
           Global  t_G.
           (    (
                  Thread3_2_Backward_AbsLocal( s_pc1, s_CL1, s_pc2, s_CL2, t_pc3, t_CL3, t_G )
                )
               &(
                  ( programInt1_3(s_pc3, t_pc3, s_CL3, t_CL3, s_G, t_G)      // Assignment related
                    & CopyVariables_ProgramInt_3(s_pc3, s_CL3, t_CL3, s_G, t_G)   //  Copy others global variable
                  )
                  | programInt3(3, s_pc3, t_pc3, s_CL3, t_CL3, s_G, t_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc3.
             (
                Thread3_2_Backward_AbsLocal( s_pc1, s_CL1, s_pc2, s_CL2, t_pc3, s_CL3, s_G )
                 & programInt2_3(s_pc3, t_pc3, s_CL3, s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread3_2_Backward_AbsLocal;
//#reset Thread3_2_Forward_AbsLocal;
#timer;

 // #####  #   #  ####   #####    #    ####          ###
 //   #    #   #  #   #  #       # #    #  #        #   #
 //   #    #   #  #   #  #      #   #   #  #            #
 //   #    #####  ####   ####   #   #   #  #          ##
 //   #    #   #  # #    #      #####   #  #         #
 //   #    #   #  #  #   #      #   #   #  #        #
 //   #    #   #  #   #  #####  #   #  ####         #####

bool Thread2_2_Forward_AbsLocal1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread2_2_Forward_AbsLocal(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G)

 );


mu bool Thread2_2_Backward_AbsLocal(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(  Thread2_2_Forward_AbsLocal1( s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G )
&
( false

  // initial configuration (init)
  |  ( exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3.
        (
             Thread3_2_Backward_AbsLocal( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G )
        )
          &  s_G.v1 = 0
        &  ContextSwitch_2(s_pc2)
        &  ContextSwitch_3(s_pc3)
     )


//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc2,
           Local   t_CL2,
           Global  t_G.
           (    (   Thread2_2_Backward_AbsLocal( s_pc1, s_CL1, t_pc2, t_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_2(s_pc2, t_pc2, s_CL2, t_CL2, s_G, t_G)      // Assignment related
                    & CopyVariables_ProgramInt_2(s_pc2, s_CL2, t_CL2, s_G, t_G)   //  Copy others global variable
                  )
                  | programInt3(2, s_pc2, t_pc2, s_CL2, t_CL2, s_G, t_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc2.
             (     Thread2_2_Backward_AbsLocal( s_pc1, s_CL1, t_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_2(s_pc2, t_pc2,s_CL2,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread2_2_Backward_AbsLocal;
//#reset Thread2_2_Forward_AbsLocal;
#timer;



// ###   #  #  ###   ####   ##   ###          #
//  #    #  #  #  #  #     #  #  #  #        ##
//  #    ####  #  #  ###   #  #  #  #         #
//  #    #  #  ###   #     ####  #  #         #
//  #    #  #  # #   #     #  #  #  #         #
//  #    #  #  #  #  ####  #  #  ###         ###


bool Thread1_2_Forward_AbsLocal1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread1_2_Forward_AbsLocal(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G)

 );


mu bool Thread1_2_Backward_AbsLocal(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(  Thread1_2_Forward_AbsLocal1( s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G )
&
( false

  // initial configuration (init)
  |  (exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3.
        (
             Thread2_2_Backward_AbsLocal( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G )
        )
          &  s_G.v1 = 0
        &  ContextSwitch_1(s_pc1)
        &  ContextSwitch_2(s_pc2)
     )

//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
         true
      & (exists                  // There exists an internal state that
           PrCount t_pc1,
           Local   t_CL1,
           Global t_G.
           (    (   Thread1_2_Backward_AbsLocal( t_pc1, t_CL1, s_pc2, s_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_1(s_pc1, t_pc1, s_CL1, t_CL1, s_G, t_G)      // Assignment related
                    & CopyVariables_ProgramInt_1(s_pc1, s_CL1, t_CL1, s_G, t_G)   //  Copy others global variable
                  )
                  | programInt3(1, s_pc1, t_pc1, s_CL1, t_CL1, s_G, t_G )   // constrain
                )
           )
      )
    )

  | (
          true
       & (exists PrCount t_pc1.
             (     Thread1_2_Backward_AbsLocal( t_pc1, s_CL1, s_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_1(s_pc1,t_pc1,s_CL1,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread1_2_Backward_AbsLocal;
//#reset Thread1_2_Forward_AbsLocal;
#timer;


// ####    ###   #   #  #   #  ####            #
// #   #  #   #  #   #  #   #   #  #          ##
// #   #  #   #  #   #  ##  #   #  #         # #
// ####   #   #  #   #  # # #   #  #           #
// # #    #   #  #   #  #  ##   #  #           #
// #  #   #   #  #   #  #   #   #  #           #
// #   #   ###    ###   #   #  ####          #####

// BACKWARD


// ###   #  #  ###   ####   ##   ###         ####
//  #    #  #  #  #  #     #  #  #  #           #
//  #    ####  #  #  ###   #  #  #  #         ##
//  #    #  #  ###   #     ####  #  #           #
//  #    #  #  # #   #     #  #  #  #        #  #
//  #    #  #  #  #  ####  #  #  ###          ##


bool Thread3_1_Forward_AbsLocal1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread3_1_Forward_AbsLocal(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G)
 );


mu bool Thread3_1_Backward_AbsLocal(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
( Thread3_1_Forward_AbsLocal1(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G)
&
( false

  // initial configuration (init)
  | (exists
        Local   t_CL1,
        Local   t_CL2,
        Local   t_CL3,
        Global  t_G.
        (
            Thread1_2_Backward_AbsLocal(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)
          & t_G.v1 = 0
        )
        & ContextSwitch_1(s_pc1)
        & ContextSwitch_3(s_pc3)
    )


//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc3,
           Local   t_CL3,
           Global  t_G.
           (    (
                  Thread3_1_Backward_AbsLocal( s_pc1, s_CL1, s_pc2, s_CL2, t_pc3, t_CL3, t_G )
                )
               &(
                  ( programInt1_3(s_pc3, t_pc3, s_CL3, t_CL3, s_G, t_G)      // Assignment related
                    & CopyVariables_ProgramInt_3(s_pc3, s_CL3, t_CL3, s_G, t_G)   //  Copy others global variable
                  )
                  | programInt3(3, s_pc3, t_pc3, s_CL3, t_CL3, s_G, t_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc3.
             (
                Thread3_1_Backward_AbsLocal( s_pc1, s_CL1, s_pc2, s_CL2, t_pc3, s_CL3, s_G )
                 & programInt2_3(s_pc3, t_pc3, s_CL3, s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread3_1_Backward_AbsLocal;
//#reset Thread3_1_Forward_AbsLocal;
#timer;

 // #####  #   #  ####   #####    #    ####          ###
 //   #    #   #  #   #  #       # #    #  #        #   #
 //   #    #   #  #   #  #      #   #   #  #            #
 //   #    #####  ####   ####   #   #   #  #          ##
 //   #    #   #  # #    #      #####   #  #         #
 //   #    #   #  #  #   #      #   #   #  #        #
 //   #    #   #  #   #  #####  #   #  ####         #####

bool Thread2_1_Forward_AbsLocal1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread2_1_Forward_AbsLocal(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G)
 );

mu bool Thread2_1_Backward_AbsLocal(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(   Thread2_1_Forward_AbsLocal1( s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G )
&
( false

  // initial configuration (init)
  |  ( exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3.
        (
             Thread3_1_Backward_AbsLocal( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G )
        )
          &  s_G.v1 = 0
        &  ContextSwitch_2(s_pc2)
        &  ContextSwitch_3(s_pc3)
     )


//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc2,
           Local   t_CL2,
           Global  t_G.
           (    (   Thread2_1_Backward_AbsLocal( s_pc1, s_CL1, t_pc2, t_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_2(s_pc2, t_pc2, s_CL2, t_CL2, s_G, t_G)      // Assignment related
                    & CopyVariables_ProgramInt_2(s_pc2, s_CL2, t_CL2, s_G, t_G)   //  Copy others global variable
                  )
                  | programInt3(2, s_pc2, t_pc2, s_CL2, t_CL2, s_G, t_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc2.
             (     Thread2_1_Backward_AbsLocal( s_pc1, s_CL1, t_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_2(s_pc2, t_pc2,s_CL2,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread2_1_Backward_AbsLocal;
//#reset Thread2_1_Forward_AbsLocal;
#timer;



// ###   #  #  ###   ####   ##   ###          #
//  #    #  #  #  #  #     #  #  #  #        ##
//  #    ####  #  #  ###   #  #  #  #         #
//  #    #  #  ###   #     ####  #  #         #
//  #    #  #  # #   #     #  #  #  #         #
//  #    #  #  #  #  ####  #  #  ###         ###

bool Thread1_1_Forward_AbsLocal1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread1_1_Forward_AbsLocal(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G)
 );

mu bool Thread1_1_Backward_AbsLocal(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(  Thread1_1_Forward_AbsLocal1( s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G )
&
( false

  // initial configuration (init)
  |  (exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3.
        (
            Thread2_1_Backward_AbsLocal( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G )
        )
          &  s_G.v1 = 0
        &  ContextSwitch_1(s_pc1)
        &  ContextSwitch_2(s_pc2)
     )

//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
         true
      & (exists                  // There exists an internal state that
           PrCount t_pc1,
           Local   t_CL1,
           Global t_G.
           (    (   Thread1_1_Backward_AbsLocal( t_pc1, t_CL1, s_pc2, s_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_1(s_pc1, t_pc1, s_CL1, t_CL1, s_G, t_G)      // Assignment related
                    & CopyVariables_ProgramInt_1(s_pc1, s_CL1, t_CL1, s_G, t_G)   //  Copy others global variable
                  )
                  | programInt3(1, s_pc1, t_pc1, s_CL1, t_CL1, s_G, t_G )   // constrain
                )
           )
      )
    )

  | (

          true
       & (exists PrCount t_pc1.
             (     Thread1_1_Backward_AbsLocal( t_pc1, s_CL1, s_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_1(s_pc1,t_pc1,s_CL1,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread1_1_Backward_AbsLocal;
//#reset Thread1_1_Forward_AbsLocal;
#timer;


// ####    ###   #   #  #   #  ####            #
// #   #  #   #  #   #  #   #   #  #          # #
// #   #  #   #  #   #  ##  #   #  #         #   #
// ####   #   #  #   #  # # #   #  #         #   #
// # #    #   #  #   #  #  ##   #  #         #   #
// #  #   #   #  #   #  #   #   #  #          # #
// #   #   ###    ###   #   #  ####            #

// BACKWARD

// ###   #  #  ###   ####   ##   ###         ####
//  #    #  #  #  #  #     #  #  #  #           #
//  #    ####  #  #  ###   #  #  #  #         ##
//  #    #  #  ###   #     ####  #  #           #
//  #    #  #  # #   #     #  #  #  #        #  #
//  #    #  #  #  #  ####  #  #  ###          ##

bool Thread3_0_Forward_AbsLocal1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread3_0_Forward_AbsLocal(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G)
 );

mu bool Thread3_0_Backward_AbsLocal(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
( Thread3_0_Forward_AbsLocal1(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G)
&
( false

  // initial configuration (init)
  | (exists
        Local   t_CL1,
        Local   t_CL2,
        Local   t_CL3,
        Global  t_G.
        (
            Thread1_1_Backward_AbsLocal(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)
          & t_G.v1 = 0
        )
        & ContextSwitch_1(s_pc1)
        & ContextSwitch_3(s_pc3)
    )


//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc3,
           Local   t_CL3,
           Global  t_G.
           (    (
                  Thread3_0_Backward_AbsLocal( s_pc1, s_CL1, s_pc2, s_CL2, t_pc3, t_CL3, t_G )
                )
               &(
                  ( programInt1_3(s_pc3, t_pc3, s_CL3, t_CL3, s_G, t_G)      // Assignment related
                    & CopyVariables_ProgramInt_3(s_pc3, s_CL3, t_CL3, s_G, t_G)   //  Copy others global variable
                  )
                  | programInt3(3, s_pc3, t_pc3, s_CL3, t_CL3, s_G, t_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc3.
             (
                Thread3_0_Backward_AbsLocal( s_pc1, s_CL1, s_pc2, s_CL2, t_pc3, s_CL3, s_G )
                 & programInt2_3(s_pc3, t_pc3, s_CL3, s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread3_0_Backward_AbsLocal;
//#reset Thread3_0_Forward_AbsLocal;
#timer;

 // #####  #   #  ####   #####    #    ####          ###
 //   #    #   #  #   #  #       # #    #  #        #   #
 //   #    #   #  #   #  #      #   #   #  #            #
 //   #    #####  ####   ####   #   #   #  #          ##
 //   #    #   #  # #    #      #####   #  #         #
 //   #    #   #  #  #   #      #   #   #  #        #
 //   #    #   #  #   #  #####  #   #  ####         #####


bool Thread2_0_Forward_AbsLocal1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread2_0_Forward_AbsLocal(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G)
 );

mu bool Thread2_0_Backward_AbsLocal(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(   Thread2_0_Forward_AbsLocal1( s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G )
&
( false

  // initial configuration (init)
  |  ( exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3.
        (
             Thread3_0_Backward_AbsLocal( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G )
        )
          &  s_G.v1 = 0
        &  ContextSwitch_2(s_pc2)
        &  ContextSwitch_3(s_pc3)
     )


//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc2,
           Local   t_CL2,
           Global  t_G.
           (    (   Thread2_0_Backward_AbsLocal( s_pc1, s_CL1, t_pc2, t_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_2(s_pc2, t_pc2, s_CL2, t_CL2, s_G, t_G)      // Assignment related
                    & CopyVariables_ProgramInt_2(s_pc2, s_CL2, t_CL2, s_G, t_G)   //  Copy others global variable
                  )
                  | programInt3(2, s_pc2, t_pc2, s_CL2, t_CL2, s_G, t_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc2.
             (     Thread2_0_Backward_AbsLocal( s_pc1, s_CL1, t_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_2(s_pc2, t_pc2,s_CL2,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread2_0_Backward_AbsLocal;
//#reset Thread2_0_Forward_AbsLocal;
#timer;



// ###   #  #  ###   ####   ##   ###          #
//  #    #  #  #  #  #     #  #  #  #        ##
//  #    ####  #  #  ###   #  #  #  #         #
//  #    #  #  ###   #     ####  #  #         #
//  #    #  #  # #   #     #  #  #  #         #
//  #    #  #  #  #  ####  #  #  ###         ###

bool Thread1_0_Forward_AbsLocal1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread1_0_Forward_AbsLocal(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G)
 );

mu bool Thread1_0_Backward_AbsLocal(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(   Thread1_0_Forward_AbsLocal1( s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G )
&
( false

  // initial configuration (init)
  |  (exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3.
        (
             Thread2_0_Backward_AbsLocal( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G )
        )
          &  s_G.v1 = 0
        &  ContextSwitch_1(s_pc1)
        &  ContextSwitch_2(s_pc2)
     )

//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
         true
      & (exists                  // There exists an internal state that
           PrCount t_pc1,
           Local   t_CL1,
           Global t_G.
           (    (   Thread1_0_Backward_AbsLocal( t_pc1, t_CL1, s_pc2, s_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_1(s_pc1, t_pc1, s_CL1, t_CL1, s_G, t_G)      // Assignment related
                    & CopyVariables_ProgramInt_1(s_pc1, s_CL1, t_CL1, s_G, t_G)   //  Copy others global variable
                  )
                  | programInt3(1, s_pc1, t_pc1, s_CL1, t_CL1, s_G, t_G )   // constrain
                )
           )
      )
    )

  | (

          true
       & (exists PrCount t_pc1.
             (     Thread1_0_Backward_AbsLocal( t_pc1, s_CL1, s_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_1(s_pc1,t_pc1,s_CL1,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread1_0_Backward_AbsLocal;
//#reset Thread1_0_Forward_AbsLocal;
#timer;

//                                                          ###
// #         #     #   #   ######  #####                   #   #
// #         #     #   #   #       #    #                      #
// #        ###     # #    #       #    #                    ##
// #        # #      #     ####    #####                       #
// #       #####     #     #       #  #                        #
// #       #   #     #     #       #   #                   #   #
// #####  ##   ##    #     ######  #    #                   ###
//

// ####    ###   #   #  #   #  ####            #
// #   #  #   #  #   #  #   #   #  #          # #
// #   #  #   #  #   #  ##  #   #  #         #   #
// ####   #   #  #   #  # # #   #  #         #   #
// # #    #   #  #   #  #  ##   #  #         #   #
// #  #   #   #  #   #  #   #   #  #          # #
// #   #   ###    ###   #   #  ####            #

// Forward abstraction

// ###   #  #  ###   ####   ##   ###          #
//  #    #  #  #  #  #     #  #  #  #        ##
//  #    ####  #  #  ###   #  #  #  #         #
//  #    #  #  ###   #     ####  #  #         #
//  #    #  #  # #   #     #  #  #  #         #
//  #    #  #  #  #  ####  #  #  ###         ###

bool Thread1_0_Backward_AbsLocal1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread1_0_Backward_AbsLocal(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G)
 );

mu bool Thread1_0_Forward_AbsLocalKeepG(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(  Thread1_0_Backward_AbsLocal1(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G)
&
( false

  // initial configuration (init)
  |  (
           initPC(s_pc1)              // Initial PC
         & initPC(s_pc2)              // Initial PC
         & initPC(s_pc3)              // Initial PC
         & GlobalInit(s_G)
     )

//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
         true
      & (exists                  // There exists an internal state that
           PrCount t_pc1,
           Local   t_CL1,
           Global t_G.
           (    (   Thread1_0_Forward_AbsLocalKeepG( t_pc1, t_CL1, s_pc2, s_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  (
                    programInt1_1(t_pc1,s_pc1,t_CL1,s_CL1,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_1(t_pc1,t_CL1,s_CL1,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(1, t_pc1, s_pc1, t_CL1, s_CL1, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (
          true
       & (exists PrCount t_pc1.
             (     Thread1_0_Forward_AbsLocalKeepG( t_pc1, s_CL1, s_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_1(t_pc1,s_pc1,s_CL1,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread1_0_Forward_AbsLocalKeepG;
//#reset Thread1_0_Backward_AbsLocal;
#timer;


 // #####  #   #  ####   #####    #    ####          ###
 //   #    #   #  #   #  #       # #    #  #        #   #
 //   #    #   #  #   #  #      #   #   #  #            #
 //   #    #####  ####   ####   #   #   #  #          ##
 //   #    #   #  # #    #      #####   #  #         #
 //   #    #   #  #  #   #      #   #   #  #        #
 //   #    #   #  #   #  #####  #   #  ####         #####

bool Thread2_0_Backward_AbsLocal1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread2_0_Backward_AbsLocal(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G)
 );

mu bool Thread2_0_Forward_AbsLocalKeepG(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(   Thread2_0_Backward_AbsLocal1( s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G )
&
( false

  // initial configuration (init)
  |  (  (exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3.
          (
                 Thread1_0_Forward_AbsLocalKeepG( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G )
          )
        )
              &  s_G.v1 = 0
        &  ContextSwitch_1(s_pc1)
     )


//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc2,
           Local   t_CL2,
           Global  t_G.
           (    (   Thread2_0_Forward_AbsLocalKeepG( s_pc1, s_CL1, t_pc2, t_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_2(t_pc2,s_pc2,t_CL2,s_CL2,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_2(t_pc2,t_CL2,s_CL2,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(2, t_pc2, s_pc2, t_CL2, s_CL2, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc2.
             (     Thread2_0_Forward_AbsLocalKeepG( s_pc1, s_CL1, t_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_2(t_pc2,s_pc2,s_CL2,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread2_0_Forward_AbsLocalKeepG;
//#reset Thread2_0_Backward_AbsLocal;
#timer;



// ###   #  #  ###   ####   ##   ###         ####
//  #    #  #  #  #  #     #  #  #  #           #
//  #    ####  #  #  ###   #  #  #  #         ##
//  #    #  #  ###   #     ####  #  #           #
//  #    #  #  # #   #     #  #  #  #        #  #
//  #    #  #  #  #  ####  #  #  ###          ##

bool Thread3_0_Backward_AbsLocal1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread3_0_Backward_AbsLocal(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G)
 );

mu bool Thread3_0_Forward_AbsLocalKeepG(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(   Thread3_0_Backward_AbsLocal1( s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G )
&
( false

  // initial configuration (init)
  |  (
        (exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3.
          (
                 Thread2_0_Forward_AbsLocalKeepG( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G )
          )
        )
              &  s_G.v1 = 0
        &  ContextSwitch_2(s_pc2)
     )


//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc3,
           Local   t_CL3,
           Global  t_G.
           (    (   Thread3_0_Forward_AbsLocalKeepG( s_pc1, s_CL1, s_pc2, s_CL2, t_pc3, t_CL3, t_G )
                )
               &(
                  ( programInt1_3(t_pc3,s_pc3,t_CL3,s_CL3,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_3(t_pc3,t_CL3,s_CL3,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(3, t_pc3, s_pc3, t_CL3, s_CL3, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc3.
             (     Thread3_0_Forward_AbsLocalKeepG( s_pc1, s_CL1, s_pc2, s_CL2,t_pc3, s_CL3, s_G )
                 & programInt2_3(t_pc3,s_pc3,s_CL3,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread3_0_Forward_AbsLocalKeepG;
//#reset Thread3_0_Backward_AbsLocal;
#timer;


// ####    ###   #   #  #   #  ####                   #
// #   #  #   #  #   #  #   #   #  #                 ##
// #   #  #   #  #   #  ##  #   #  #                # #
// ####   #   #  #   #  # # #   #  #                  #
// # #    #   #  #   #  #  ##   #  #                  #
// #  #   #   #  #   #  #   #   #  #                  #
// #   #   ###    ###   #   #  ####                 #####

// FORWARD ABSTRACTION

// ###   #  #  ###   ####   ##   ###          #
//  #    #  #  #  #  #     #  #  #  #        ##
//  #    ####  #  #  ###   #  #  #  #         #
//  #    #  #  ###   #     ####  #  #         #
//  #    #  #  # #   #     #  #  #  #         #
//  #    #  #  #  #  ####  #  #  ###         ###

bool Thread1_1_Backward_AbsLocal1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread1_1_Backward_AbsLocal(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G)
 );

mu bool Thread1_1_Forward_AbsLocalKeepG(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(   Thread1_1_Backward_AbsLocal1( s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G )
&
( false

  // initial configuration (init)
  |  (
        (exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3.
          (
                 Thread3_0_Forward_AbsLocalKeepG( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G )
          )
        )
              &  s_G.v1 = 0
        &  ContextSwitch_3(s_pc3)
     )

//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
         true
      & (exists                  // There exists an internal state that
           PrCount t_pc1,
           Local   t_CL1,
           Global t_G.
           (    (   Thread1_1_Forward_AbsLocalKeepG( t_pc1, t_CL1, s_pc2, s_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_1(t_pc1,s_pc1,t_CL1,s_CL1,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_1(t_pc1,t_CL1,s_CL1,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(1, t_pc1, s_pc1, t_CL1, s_CL1, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc1.
             (     Thread1_1_Forward_AbsLocalKeepG( t_pc1, s_CL1, s_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_1(t_pc1,s_pc1,s_CL1,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread1_1_Forward_AbsLocalKeepG;
//#reset Thread1_1_Backward_AbsLocal;
#timer;

 // #####  #   #  ####   #####    #    ####          ###
 //   #    #   #  #   #  #       # #    #  #        #   #
 //   #    #   #  #   #  #      #   #   #  #            #
 //   #    #####  ####   ####   #   #   #  #          ##
 //   #    #   #  # #    #      #####   #  #         #
 //   #    #   #  #  #   #      #   #   #  #        #
 //   #    #   #  #   #  #####  #   #  ####         #####

bool Thread2_1_Backward_AbsLocal1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread2_1_Backward_AbsLocal(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G)
 );

mu bool Thread2_1_Forward_AbsLocalKeepG(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(  Thread2_1_Backward_AbsLocal1( s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G )
&
( false

  // initial configuration (init)
  |  (
        (exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3.
          (
                 Thread1_1_Forward_AbsLocalKeepG( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G )
          )
        )
              &  s_G.v1 = 0
        &  ContextSwitch_1(s_pc1)
     )

//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc2,
           Local   t_CL2,
           Global  t_G.
           (    (
                    Thread2_1_Forward_AbsLocalKeepG( s_pc1, s_CL1, t_pc2, t_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_2(t_pc2,s_pc2,t_CL2,s_CL2,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_2(t_pc2,t_CL2,s_CL2,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(2, t_pc2, s_pc2, t_CL2, s_CL2, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc2.
             (
                  Thread2_1_Forward_AbsLocalKeepG( s_pc1, s_CL1, t_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_2(t_pc2,s_pc2,s_CL2,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread2_1_Forward_AbsLocalKeepG;
//#reset Thread2_1_Backward_AbsLocal;
#timer;

// ###   #  #  ###   ####   ##   ###         ####
//  #    #  #  #  #  #     #  #  #  #           #
//  #    ####  #  #  ###   #  #  #  #         ##
//  #    #  #  ###   #     ####  #  #           #
//  #    #  #  # #   #     #  #  #  #        #  #
//  #    #  #  #  #  ####  #  #  ###          ##

bool Thread3_1_Backward_AbsLocal1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread3_1_Backward_AbsLocal(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G)
 );

mu bool Thread3_1_Forward_AbsLocalKeepG(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                      // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(   Thread3_1_Backward_AbsLocal1( s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G )
&
( false
  // initial configuration (init)
  |  (
        (exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3.
          (
                 Thread2_1_Forward_AbsLocalKeepG( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G )
          )
        )
              &  s_G.v1 = 0
        &  ContextSwitch_2(s_pc2)
     )

//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc3,
           Local   t_CL3,
           Global  t_G.
           (    (
                   Thread3_1_Forward_AbsLocalKeepG( s_pc1, s_CL1, s_pc2, s_CL2, t_pc3, t_CL3, t_G )
                )
               &(
                  ( programInt1_3(t_pc3,s_pc3,t_CL3,s_CL3,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_3(t_pc3,t_CL3,s_CL3,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(3, t_pc3, s_pc3, t_CL3, s_CL3, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc3.
             (
              Thread3_1_Forward_AbsLocalKeepG( s_pc1, s_CL1, s_pc2, s_CL2,t_pc3, s_CL3, s_G )
                 & programInt2_3(t_pc3,s_pc3,s_CL3,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread3_1_Forward_AbsLocalKeepG;
//#reset Thread3_1_Backward_AbsLocal;
#timer;



// ####    ###   #   #  #   #  ####           ###
// #   #  #   #  #   #  #   #   #  #         #   #
// #   #  #   #  #   #  ##  #   #  #             #
// ####   #   #  #   #  # # #   #  #           ##
// # #    #   #  #   #  #  ##   #  #          #
// #  #   #   #  #   #  #   #   #  #         #
// #   #   ###    ###   #   #  ####          #####

// FORWARD ABSTRACTION


// ###   #  #  ###   ####   ##   ###          #
//  #    #  #  #  #  #     #  #  #  #        ##
//  #    ####  #  #  ###   #  #  #  #         #
//  #    #  #  ###   #     ####  #  #         #
//  #    #  #  # #   #     #  #  #  #         #
//  #    #  #  #  #  ####  #  #  ###         ###

bool Thread1_2_Backward_AbsLocal1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread1_2_Backward_AbsLocal(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G)
 );

mu bool Thread1_2_Forward_AbsLocalKeepG(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(   Thread1_2_Backward_AbsLocal1( s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G )
&
( false

  // initial configuration (init)
  |  (
        (exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3.
          (
                 Thread3_1_Forward_AbsLocalKeepG( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G )
          )
        )
              &  s_G.v1 = 0
        &  ContextSwitch_3(s_pc3)
     )

//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
         true
      & (exists                  // There exists an internal state that
           PrCount t_pc1,
           Local   t_CL1,
           Global t_G.
           (    (   Thread1_2_Forward_AbsLocalKeepG( t_pc1, t_CL1, s_pc2, s_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_1(t_pc1,s_pc1,t_CL1,s_CL1,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_1(t_pc1,t_CL1,s_CL1,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(1, t_pc1, s_pc1, t_CL1, s_CL1, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc1.
             (     Thread1_2_Forward_AbsLocalKeepG( t_pc1, s_CL1, s_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_1(t_pc1,s_pc1,s_CL1,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread1_2_Forward_AbsLocalKeepG;
//#reset Thread1_2_Backward_AbsLocal;
#timer;

 // #####  #   #  ####   #####    #    ####          ###
 //   #    #   #  #   #  #       # #    #  #        #   #
 //   #    #   #  #   #  #      #   #   #  #            #
 //   #    #####  ####   ####   #   #   #  #          ##
 //   #    #   #  # #    #      #####   #  #         #
 //   #    #   #  #  #   #      #   #   #  #        #
 //   #    #   #  #   #  #####  #   #  ####         #####

bool Thread2_2_Backward_AbsLocal1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread2_2_Backward_AbsLocal(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G)
 );

mu bool Thread2_2_Forward_AbsLocalKeepG(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(   Thread2_2_Backward_AbsLocal1( s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G )
&
( false

  // initial configuration (init)
  |  (
        (exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3.
          (
                 Thread1_2_Forward_AbsLocalKeepG( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G )
          )
        )
        &  s_G.v1 = 0
        &  ContextSwitch_1(s_pc1)
     )

//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc2,
           Local   t_CL2,
           Global  t_G.
           (    (   Thread2_2_Forward_AbsLocalKeepG( s_pc1, s_CL1, t_pc2, t_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_2(t_pc2,s_pc2,t_CL2,s_CL2,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_2(t_pc2,t_CL2,s_CL2,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(2, t_pc2, s_pc2, t_CL2, s_CL2, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc2.
             (     Thread2_2_Forward_AbsLocalKeepG( s_pc1, s_CL1, t_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_2(t_pc2,s_pc2,s_CL2,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread2_2_Forward_AbsLocalKeepG;
//#reset Thread2_2_Backward_AbsLocal;
#timer;

// ###   #  #  ###   ####   ##   ###         ####
//  #    #  #  #  #  #     #  #  #  #           #
//  #    ####  #  #  ###   #  #  #  #         ##
//  #    #  #  ###   #     ####  #  #           #
//  #    #  #  # #   #     #  #  #  #        #  #
//  #    #  #  #  #  ####  #  #  ###          ##

bool Thread3_2_Backward_AbsLocal1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread3_2_Backward_AbsLocal(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G)
 );

mu bool Thread3_2_Forward_AbsLocalKeepG(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                      // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(   Thread3_2_Backward_AbsLocal1( s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G )
&
( false
  // initial configuration (init)
  |  (
        (exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3.
          (
                 Thread2_2_Forward_AbsLocalKeepG( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G )
          )
        )
        &  s_G.v1 = 0
        &  ContextSwitch_2(s_pc2)
     )

//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc3,
           Local   t_CL3,
           Global  t_G.
           (    (   Thread3_2_Forward_AbsLocalKeepG( s_pc1, s_CL1, s_pc2, s_CL2, t_pc3, t_CL3, t_G )
                )
               &(
                  ( programInt1_3(t_pc3,s_pc3,t_CL3,s_CL3,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_3(t_pc3,t_CL3,s_CL3,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(3, t_pc3, s_pc3, t_CL3, s_CL3, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc3.
             (     Thread3_2_Forward_AbsLocalKeepG( s_pc1, s_CL1, s_pc2, s_CL2,t_pc3, s_CL3, s_G )
                 & programInt2_3(t_pc3,s_pc3,s_CL3,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread3_2_Forward_AbsLocalKeepG;
//#reset Thread3_2_Backward_AbsLocal;
#timer;


// ####    ###   #   #  #   #  ####          #####
// #   #  #   #  #   #  #   #   #  #             #
// #   #  #   #  #   #  ##  #   #  #            #
// ####   #   #  #   #  # # #   #  #           ##
// # #    #   #  #   #  #  ##   #  #             #
// #  #   #   #  #   #  #   #   #  #         #   #
// #   #   ###    ###   #   #  ####           ###

// FORWARD ABSTRACTION

// ###   #  #  ###   ####   ##   ###          #
//  #    #  #  #  #  #     #  #  #  #        ##
//  #    ####  #  #  ###   #  #  #  #         #
//  #    #  #  ###   #     ####  #  #         #
//  #    #  #  # #   #     #  #  #  #         #
//  #    #  #  #  #  ####  #  #  ###         ###

bool Thread1_3_Backward_AbsLocal1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread1_3_Backward_AbsLocal(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G)
 );

mu bool Thread1_3_Forward_AbsLocalKeepG(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(  Thread1_3_Backward_AbsLocal1( s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G )
&
( false

  // initial configuration (init)
  |  (
        (exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3.
          (
                 Thread3_2_Forward_AbsLocalKeepG( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G )
          )
        )
              &  s_G.v1 = 0
        &  ContextSwitch_3(s_pc3)
     )

//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
         true
      & (exists                  // There exists an internal state that
           PrCount t_pc1,
           Local   t_CL1,
           Global t_G.
           (    (   Thread1_3_Forward_AbsLocalKeepG( t_pc1, t_CL1, s_pc2, s_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_1(t_pc1,s_pc1,t_CL1,s_CL1,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_1(t_pc1,t_CL1,s_CL1,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(1, t_pc1, s_pc1, t_CL1, s_CL1, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc1.
             (     Thread1_3_Forward_AbsLocalKeepG( t_pc1, s_CL1, s_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_1(t_pc1,s_pc1,s_CL1,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread1_3_Forward_AbsLocalKeepG;
//#reset Thread1_3_Backward_AbsLocal;
#timer;

 // #####  #   #  ####   #####    #    ####          ###
 //   #    #   #  #   #  #       # #    #  #        #   #
 //   #    #   #  #   #  #      #   #   #  #            #
 //   #    #####  ####   ####   #   #   #  #          ##
 //   #    #   #  # #    #      #####   #  #         #
 //   #    #   #  #  #   #      #   #   #  #        #
 //   #    #   #  #   #  #####  #   #  ####         #####

bool Thread2_3_Backward_AbsLocal1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread2_3_Backward_AbsLocal(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G)
 );

mu bool Thread2_3_Forward_AbsLocalKeepG(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(   Thread2_3_Backward_AbsLocal1( s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G )
&
( false

  // initial configuration (init)
  |  (
        (exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3.
          (
                 Thread1_3_Forward_AbsLocalKeepG( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G )
          )
        )
              &  s_G.v1 = 0
        &  ContextSwitch_1(s_pc1)
     )

//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc2,
           Local   t_CL2,
           Global  t_G.
           (    (   Thread2_3_Forward_AbsLocalKeepG( s_pc1, s_CL1, t_pc2, t_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_2(t_pc2,s_pc2,t_CL2,s_CL2,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_2(t_pc2,t_CL2,s_CL2,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(2, t_pc2, s_pc2, t_CL2, s_CL2, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc2.
             (     Thread2_3_Forward_AbsLocalKeepG( s_pc1, s_CL1, t_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_2(t_pc2,s_pc2,s_CL2,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread2_3_Forward_AbsLocalKeepG;
//#reset Thread2_3_Backward_AbsLocal;
#timer;

// ###   #  #  ###   ####   ##   ###         ####
//  #    #  #  #  #  #     #  #  #  #           #
//  #    ####  #  #  ###   #  #  #  #         ##
//  #    #  #  ###   #     ####  #  #           #
//  #    #  #  # #   #     #  #  #  #        #  #
//  #    #  #  #  #  ####  #  #  ###          ##

bool Thread3_3_Backward_AbsLocal1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread3_3_Backward_AbsLocal(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G)
 );

mu bool Thread3_3_Forward_AbsLocalKeepG(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                      // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(   Thread3_3_Backward_AbsLocal1( s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G )
&
( false
  // initial configuration (init)
  |  (
        (exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3.
          (
                 Thread2_3_Forward_AbsLocalKeepG( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G )
          )
        )
              &  s_G.v1 = 0
        &  ContextSwitch_2(s_pc2)
     )

//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc3,
           Local   t_CL3,
           Global  t_G.
           (    (   Thread3_3_Forward_AbsLocalKeepG( s_pc1, s_CL1, s_pc2, s_CL2, t_pc3, t_CL3, t_G )
                )
               &(
                  ( programInt1_3(t_pc3,s_pc3,t_CL3,s_CL3,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_3(t_pc3,t_CL3,s_CL3,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(3, t_pc3, s_pc3, t_CL3, s_CL3, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc3.
             (     Thread3_3_Forward_AbsLocalKeepG( s_pc1, s_CL1, s_pc2, s_CL2,t_pc3, s_CL3, s_G )
                 & programInt2_3(t_pc3,s_pc3,s_CL3,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread3_3_Forward_AbsLocalKeepG;
//#reset Thread3_3_Backward_AbsLocal;
#timer;

// ####    ###   #   #  #   #  ####          #####
// #   #  #   #  #   #  #   #   #  #             #
// #   #  #   #  #   #  ##  #   #  #            #
// ####   #   #  #   #  # # #   #  #           ##
// # #    #   #  #   #  #  ##   #  #             #
// #  #   #   #  #   #  #   #   #  #         #   #
// #   #   ###    ###   #   #  ####           ###

// BACKWARD

// ###   #  #  ###   ####   ##   ###         ####
//  #    #  #  #  #  #     #  #  #  #           #
//  #    ####  #  #  ###   #  #  #  #         ##
//  #    #  #  ###   #     ####  #  #           #
//  #    #  #  # #   #     #  #  #  #        #  #
//  #    #  #  #  #  ####  #  #  ###          ##

bool Thread3_3_Forward_AbsLocalKeepG1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread3_3_Forward_AbsLocalKeepG(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G)
 );

mu bool Thread3_3_Backward_AbsLocalKeepG(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(   Thread3_3_Forward_AbsLocalKeepG1(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G)
&
( false

  // initial configuration (init)
  | (
      // target
      (
          target(1, s_pc1)
        | target(2, s_pc2)
        | target(3, s_pc3)
      )
    )


//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc3,
           Local   t_CL3,
           Global  t_G.
           (    (
                  Thread3_3_Backward_AbsLocalKeepG( s_pc1, s_CL1, s_pc2, s_CL2, t_pc3, t_CL3, t_G )
                )
               &(
                  ( programInt1_3(s_pc3, t_pc3, s_CL3, t_CL3, s_G, t_G)      // Assignment related
                    & CopyVariables_ProgramInt_3(s_pc3, s_CL3, t_CL3, s_G, t_G)   //  Copy others global variable
                  )
                  | programInt3(3, s_pc3, t_pc3, s_CL3, t_CL3, s_G, t_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc3.
             (
                Thread3_3_Backward_AbsLocalKeepG( s_pc1, s_CL1, s_pc2, s_CL2, t_pc3, s_CL3, s_G )
                 & programInt2_3(s_pc3, t_pc3, s_CL3, s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread3_3_Backward_AbsLocalKeepG;
//#reset Thread3_3_Forward_AbsLocalKeepG;
#timer;

 // #####  #   #  ####   #####    #    ####          ###
 //   #    #   #  #   #  #       # #    #  #        #   #
 //   #    #   #  #   #  #      #   #   #  #            #
 //   #    #####  ####   ####   #   #   #  #          ##
 //   #    #   #  # #    #      #####   #  #         #
 //   #    #   #  #  #   #      #   #   #  #        #
 //   #    #   #  #   #  #####  #   #  ####         #####

bool Thread2_3_Forward_AbsLocalKeepG1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread2_3_Forward_AbsLocalKeepG(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G)
 );

mu bool Thread2_3_Backward_AbsLocalKeepG(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(   Thread2_3_Forward_AbsLocalKeepG1(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G)
&
( false

  // initial configuration (init)
  |  (
        (exists
            Local   t_CL1,
            Local   t_CL2,
            Local   t_CL3.
            (
                Thread3_3_Backward_AbsLocalKeepG( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G )
            )
        )
              & s_G.v1 = 0
        &  ContextSwitch_2(s_pc2)
        &  ContextSwitch_3(s_pc3)
     )


//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc2,
           Local   t_CL2,
           Global  t_G.
           (    (   Thread2_3_Backward_AbsLocalKeepG( s_pc1, s_CL1, t_pc2, t_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_2(s_pc2, t_pc2, s_CL2, t_CL2, s_G, t_G)      // Assignment related
                    & CopyVariables_ProgramInt_2(s_pc2, s_CL2, t_CL2, s_G, t_G)   //  Copy others global variable
                  )
                  | programInt3(2, s_pc2, t_pc2, s_CL2, t_CL2, s_G, t_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc2.
             (     Thread2_3_Backward_AbsLocalKeepG( s_pc1, s_CL1, t_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_2(s_pc2, t_pc2,s_CL2,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread2_3_Backward_AbsLocalKeepG;
//#reset Thread2_3_Forward_AbsLocalKeepG;
#timer;

// ###   #  #  ###   ####   ##   ###          #
//  #    #  #  #  #  #     #  #  #  #        ##
//  #    ####  #  #  ###   #  #  #  #         #
//  #    #  #  ###   #     ####  #  #         #
//  #    #  #  # #   #     #  #  #  #         #
//  #    #  #  #  #  ####  #  #  ###         ###

bool Thread1_3_Forward_AbsLocalKeepG1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread1_3_Forward_AbsLocalKeepG(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G)
 );

mu bool Thread1_3_Backward_AbsLocalKeepG(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(  Thread1_3_Forward_AbsLocalKeepG1( s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G )
&
( false

  // initial configuration (init)
  |  (
        (exists
            Local   t_CL1,
            Local   t_CL2,
            Local   t_CL3.
            (
                Thread2_3_Backward_AbsLocalKeepG( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G )
            )
        )
              & s_G.v1 = 0
        &  ContextSwitch_1(s_pc1)
        &  ContextSwitch_2(s_pc2)
     )

//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
         true
      & (exists                  // There exists an internal state that
           PrCount t_pc1,
           Local   t_CL1,
           Global t_G.
           (    (   Thread1_3_Backward_AbsLocalKeepG( t_pc1, t_CL1, s_pc2, s_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_1(s_pc1, t_pc1, s_CL1, t_CL1, s_G, t_G)      // Assignment related
                    & CopyVariables_ProgramInt_1(s_pc1, s_CL1, t_CL1, s_G, t_G)   //  Copy others global variable
                  )
                  | programInt3(1, s_pc1, t_pc1, s_CL1, t_CL1, s_G, t_G )   // constrain
                )
           )
      )
    )

  | (
          true
       & (exists PrCount t_pc1.
             (     Thread1_3_Backward_AbsLocalKeepG( t_pc1, s_CL1, s_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_1(s_pc1,t_pc1,s_CL1,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread1_3_Backward_AbsLocalKeepG;
//#reset Thread1_3_Forward_AbsLocalKeepG;
#timer;


// ####    ###   #   #  #   #  ####           ###
 // #   #  #   #  #   #  #   #   #  #         #   #
 // #   #  #   #  #   #  ##  #   #  #             #
 // ####   #   #  #   #  # # #   #  #           ##
 // # #    #   #  #   #  #  ##   #  #          #
 // #  #   #   #  #   #  #   #   #  #         #
 // #   #   ###    ###   #   #  ####          #####

// BACKWARD

// ###   #  #  ###   ####   ##   ###         ####
//  #    #  #  #  #  #     #  #  #  #           #
//  #    ####  #  #  ###   #  #  #  #         ##
//  #    #  #  ###   #     ####  #  #           #
//  #    #  #  # #   #     #  #  #  #        #  #
//  #    #  #  #  #  ####  #  #  ###          ##


bool Thread3_2_Forward_AbsLocalKeepG1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread3_2_Forward_AbsLocalKeepG(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G)
 );

mu bool Thread3_2_Backward_AbsLocalKeepG(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(  Thread3_2_Forward_AbsLocalKeepG1(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G)
&
( false

  // initial configuration (init)
  | (exists
        Local   t_CL1,
        Local   t_CL2,
        Local   t_CL3,
        Global  t_G.
        (
            Thread1_3_Backward_AbsLocalKeepG(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)
          & t_G.v1 = 0
        )
        & ContextSwitch_1(s_pc1)
        & ContextSwitch_3(s_pc3)
    )


//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc3,
           Local   t_CL3,
           Global  t_G.
           (    (
                  Thread3_2_Backward_AbsLocalKeepG( s_pc1, s_CL1, s_pc2, s_CL2, t_pc3, t_CL3, t_G )
                )
               &(
                  ( programInt1_3(s_pc3, t_pc3, s_CL3, t_CL3, s_G, t_G)      // Assignment related
                    & CopyVariables_ProgramInt_3(s_pc3, s_CL3, t_CL3, s_G, t_G)   //  Copy others global variable
                  )
                  | programInt3(3, s_pc3, t_pc3, s_CL3, t_CL3, s_G, t_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc3.
             (
                Thread3_2_Backward_AbsLocalKeepG( s_pc1, s_CL1, s_pc2, s_CL2, t_pc3, s_CL3, s_G )
                 & programInt2_3(s_pc3, t_pc3, s_CL3, s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread3_2_Backward_AbsLocalKeepG;
//#reset Thread3_2_Forward_AbsLocalKeepG;
#timer;

 // #####  #   #  ####   #####    #    ####          ###
 //   #    #   #  #   #  #       # #    #  #        #   #
 //   #    #   #  #   #  #      #   #   #  #            #
 //   #    #####  ####   ####   #   #   #  #          ##
 //   #    #   #  # #    #      #####   #  #         #
 //   #    #   #  #  #   #      #   #   #  #        #
 //   #    #   #  #   #  #####  #   #  ####         #####

bool Thread2_2_Forward_AbsLocalKeepG1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread2_2_Forward_AbsLocalKeepG(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G)
 );


mu bool Thread2_2_Backward_AbsLocalKeepG(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(   Thread2_2_Forward_AbsLocalKeepG1( s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G )
&
( false

  // initial configuration (init)
  |  ( exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3.
        (
             Thread3_2_Backward_AbsLocalKeepG( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G )
        )
          &  s_G.v1 = 0
        &  ContextSwitch_2(s_pc2)
        &  ContextSwitch_3(s_pc3)
     )


//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc2,
           Local   t_CL2,
           Global  t_G.
           (    (   Thread2_2_Backward_AbsLocalKeepG( s_pc1, s_CL1, t_pc2, t_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_2(s_pc2, t_pc2, s_CL2, t_CL2, s_G, t_G)      // Assignment related
                    & CopyVariables_ProgramInt_2(s_pc2, s_CL2, t_CL2, s_G, t_G)   //  Copy others global variable
                  )
                  | programInt3(2, s_pc2, t_pc2, s_CL2, t_CL2, s_G, t_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc2.
             (     Thread2_2_Backward_AbsLocalKeepG( s_pc1, s_CL1, t_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_2(s_pc2, t_pc2,s_CL2,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread2_2_Backward_AbsLocalKeepG;
//#reset Thread2_2_Forward_AbsLocalKeepG;
#timer;



// ###   #  #  ###   ####   ##   ###          #
//  #    #  #  #  #  #     #  #  #  #        ##
//  #    ####  #  #  ###   #  #  #  #         #
//  #    #  #  ###   #     ####  #  #         #
//  #    #  #  # #   #     #  #  #  #         #
//  #    #  #  #  #  ####  #  #  ###         ###


bool Thread1_2_Forward_AbsLocalKeepG1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread1_2_Forward_AbsLocalKeepG(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G)
 );

mu bool Thread1_2_Backward_AbsLocalKeepG(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(   Thread1_2_Forward_AbsLocalKeepG1( s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G )
&
( false

  // initial configuration (init)
  |  (exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3.
        (
             Thread2_2_Backward_AbsLocalKeepG( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G )
        )
          &  s_G.v1 = 0
        &  ContextSwitch_1(s_pc1)
        &  ContextSwitch_2(s_pc2)
     )

//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
         true
      & (exists                  // There exists an internal state that
           PrCount t_pc1,
           Local   t_CL1,
           Global t_G.
           (    (   Thread1_2_Backward_AbsLocalKeepG( t_pc1, t_CL1, s_pc2, s_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_1(s_pc1, t_pc1, s_CL1, t_CL1, s_G, t_G)      // Assignment related
                    & CopyVariables_ProgramInt_1(s_pc1, s_CL1, t_CL1, s_G, t_G)   //  Copy others global variable
                  )
                  | programInt3(1, s_pc1, t_pc1, s_CL1, t_CL1, s_G, t_G )   // constrain
                )
           )
      )
    )

  | (
          true
       & (exists PrCount t_pc1.
             (     Thread1_2_Backward_AbsLocalKeepG( t_pc1, s_CL1, s_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_1(s_pc1,t_pc1,s_CL1,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread1_2_Backward_AbsLocalKeepG;
//#reset Thread1_2_Forward_AbsLocalKeepG;
#timer;


// ####    ###   #   #  #   #  ####            #
// #   #  #   #  #   #  #   #   #  #          ##
// #   #  #   #  #   #  ##  #   #  #         # #
// ####   #   #  #   #  # # #   #  #           #
// # #    #   #  #   #  #  ##   #  #           #
// #  #   #   #  #   #  #   #   #  #           #
// #   #   ###    ###   #   #  ####          #####

// BACKWARD


// ###   #  #  ###   ####   ##   ###         ####
//  #    #  #  #  #  #     #  #  #  #           #
//  #    ####  #  #  ###   #  #  #  #         ##
//  #    #  #  ###   #     ####  #  #           #
//  #    #  #  # #   #     #  #  #  #        #  #
//  #    #  #  #  #  ####  #  #  ###          ##

bool Thread3_1_Forward_AbsLocalKeepG1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread3_1_Forward_AbsLocalKeepG(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G)
 );

mu bool Thread3_1_Backward_AbsLocalKeepG(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(  Thread3_1_Forward_AbsLocalKeepG1(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G)
&
( false

  // initial configuration (init)
  | (exists
        Local   t_CL1,
        Local   t_CL2,
        Local   t_CL3,
        Global  t_G.
        (
            Thread1_2_Backward_AbsLocalKeepG(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G)
          & t_G.v1 = 0
        )
        & ContextSwitch_1(s_pc1)
        & ContextSwitch_3(s_pc3)
    )


//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc3,
           Local   t_CL3,
           Global  t_G.
           (    (
                  Thread3_1_Backward_AbsLocalKeepG( s_pc1, s_CL1, s_pc2, s_CL2, t_pc3, t_CL3, t_G )
                )
               &(
                  ( programInt1_3(s_pc3, t_pc3, s_CL3, t_CL3, s_G, t_G)      // Assignment related
                    & CopyVariables_ProgramInt_3(s_pc3, s_CL3, t_CL3, s_G, t_G)   //  Copy others global variable
                  )
                  | programInt3(3, s_pc3, t_pc3, s_CL3, t_CL3, s_G, t_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc3.
             (
                Thread3_1_Backward_AbsLocalKeepG( s_pc1, s_CL1, s_pc2, s_CL2, t_pc3, s_CL3, s_G )
                 & programInt2_3(s_pc3, t_pc3, s_CL3, s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread3_1_Backward_AbsLocalKeepG;
//#reset Thread3_1_Forward_AbsLocalKeepG;
#timer;

 // #####  #   #  ####   #####    #    ####          ###
 //   #    #   #  #   #  #       # #    #  #        #   #
 //   #    #   #  #   #  #      #   #   #  #            #
 //   #    #####  ####   ####   #   #   #  #          ##
 //   #    #   #  # #    #      #####   #  #         #
 //   #    #   #  #  #   #      #   #   #  #        #
 //   #    #   #  #   #  #####  #   #  ####         #####

bool Thread2_1_Forward_AbsLocalKeepG1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread2_1_Forward_AbsLocalKeepG(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G)
 );

mu bool Thread2_1_Backward_AbsLocalKeepG(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(   Thread2_1_Forward_AbsLocalKeepG1( s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G )
&
( false

  // initial configuration (init)
  |  ( exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3.
        (
             Thread3_1_Backward_AbsLocalKeepG( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G )
        )
          &  s_G.v1 = 0
        &  ContextSwitch_2(s_pc2)
        &  ContextSwitch_3(s_pc3)
     )


//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc2,
           Local   t_CL2,
           Global  t_G.
           (    (   Thread2_1_Backward_AbsLocalKeepG( s_pc1, s_CL1, t_pc2, t_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_2(s_pc2, t_pc2, s_CL2, t_CL2, s_G, t_G)      // Assignment related
                    & CopyVariables_ProgramInt_2(s_pc2, s_CL2, t_CL2, s_G, t_G)   //  Copy others global variable
                  )
                  | programInt3(2, s_pc2, t_pc2, s_CL2, t_CL2, s_G, t_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc2.
             (     Thread2_1_Backward_AbsLocalKeepG( s_pc1, s_CL1, t_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_2(s_pc2, t_pc2,s_CL2,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread2_1_Backward_AbsLocalKeepG;
//#reset Thread2_1_Forward_AbsLocalKeepG;
#timer;



// ###   #  #  ###   ####   ##   ###          #
//  #    #  #  #  #  #     #  #  #  #        ##
//  #    ####  #  #  ###   #  #  #  #         #
//  #    #  #  ###   #     ####  #  #         #
//  #    #  #  # #   #     #  #  #  #         #
//  #    #  #  #  #  ####  #  #  ###         ###

bool Thread1_1_Forward_AbsLocalKeepG1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread1_1_Forward_AbsLocalKeepG(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G)
 );

mu bool Thread1_1_Backward_AbsLocalKeepG(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(   Thread1_1_Forward_AbsLocalKeepG1( s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G )
&
( false

  // initial configuration (init)
  |  (exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3.
        (
            Thread2_1_Backward_AbsLocalKeepG( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G )
        )
          &  s_G.v1 = 0
        &  ContextSwitch_1(s_pc1)
        &  ContextSwitch_2(s_pc2)
     )

//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
         true
      & (exists                  // There exists an internal state that
           PrCount t_pc1,
           Local   t_CL1,
           Global t_G.
           (    (   Thread1_1_Backward_AbsLocalKeepG( t_pc1, t_CL1, s_pc2, s_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_1(s_pc1, t_pc1, s_CL1, t_CL1, s_G, t_G)      // Assignment related
                    & CopyVariables_ProgramInt_1(s_pc1, s_CL1, t_CL1, s_G, t_G)   //  Copy others global variable
                  )
                  | programInt3(1, s_pc1, t_pc1, s_CL1, t_CL1, s_G, t_G )   // constrain
                )
           )
      )
    )

  | (

          true
       & (exists PrCount t_pc1.
             (     Thread1_1_Backward_AbsLocalKeepG( t_pc1, s_CL1, s_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_1(s_pc1,t_pc1,s_CL1,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread1_1_Backward_AbsLocalKeepG;
//#reset Thread1_1_Forward_AbsLocalKeepG;
#timer;


// ####    ###   #   #  #   #  ####            #
// #   #  #   #  #   #  #   #   #  #          # #
// #   #  #   #  #   #  ##  #   #  #         #   #
// ####   #   #  #   #  # # #   #  #         #   #
// # #    #   #  #   #  #  ##   #  #         #   #
// #  #   #   #  #   #  #   #   #  #          # #
// #   #   ###    ###   #   #  ####            #

// BACKWARD

// ###   #  #  ###   ####   ##   ###         ####
//  #    #  #  #  #  #     #  #  #  #           #
//  #    ####  #  #  ###   #  #  #  #         ##
//  #    #  #  ###   #     ####  #  #           #
//  #    #  #  # #   #     #  #  #  #        #  #
//  #    #  #  #  #  ####  #  #  ###          ##

bool Thread3_0_Forward_AbsLocalKeepG1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread3_0_Forward_AbsLocalKeepG(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G)
 );

mu bool Thread3_0_Backward_AbsLocalKeepG(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(  Thread3_0_Forward_AbsLocalKeepG1(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G)
&
( false

  // initial configuration (init)
  | (exists
        Local   t_CL1,
        Local   t_CL2,
        Local   t_CL3,
        Global  t_G.
        (
            Thread1_1_Backward_AbsLocalKeepG(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G)
          & t_G.v1 = 0
        )
        & ContextSwitch_1(s_pc1)
        & ContextSwitch_3(s_pc3)
    )


//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc3,
           Local   t_CL3,
           Global  t_G.
           (    (
                  Thread3_0_Backward_AbsLocalKeepG( s_pc1, s_CL1, s_pc2, s_CL2, t_pc3, t_CL3, t_G )
                )
               &(
                  ( programInt1_3(s_pc3, t_pc3, s_CL3, t_CL3, s_G, t_G)      // Assignment related
                    & CopyVariables_ProgramInt_3(s_pc3, s_CL3, t_CL3, s_G, t_G)   //  Copy others global variable
                  )
                  | programInt3(3, s_pc3, t_pc3, s_CL3, t_CL3, s_G, t_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc3.
             (
                Thread3_0_Backward_AbsLocalKeepG( s_pc1, s_CL1, s_pc2, s_CL2, t_pc3, s_CL3, s_G )
                 & programInt2_3(s_pc3, t_pc3, s_CL3, s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread3_0_Backward_AbsLocalKeepG;
//#reset Thread3_0_Forward_AbsLocalKeepG;
#timer;

 // #####  #   #  ####   #####    #    ####          ###
 //   #    #   #  #   #  #       # #    #  #        #   #
 //   #    #   #  #   #  #      #   #   #  #            #
 //   #    #####  ####   ####   #   #   #  #          ##
 //   #    #   #  # #    #      #####   #  #         #
 //   #    #   #  #  #   #      #   #   #  #        #
 //   #    #   #  #   #  #####  #   #  ####         #####

bool Thread2_0_Forward_AbsLocalKeepG1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread2_0_Forward_AbsLocalKeepG(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G)
 );

mu bool Thread2_0_Backward_AbsLocalKeepG(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(   Thread2_0_Forward_AbsLocalKeepG1( s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G )
&
( false

  // initial configuration (init)
  |  ( exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3.
        (
             Thread3_0_Backward_AbsLocalKeepG( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G )
        )
          &  s_G.v1 = 0
        &  ContextSwitch_2(s_pc2)
        &  ContextSwitch_3(s_pc3)
     )


//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc2,
           Local   t_CL2,
           Global  t_G.
           (    (   Thread2_0_Backward_AbsLocalKeepG( s_pc1, s_CL1, t_pc2, t_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_2(s_pc2, t_pc2, s_CL2, t_CL2, s_G, t_G)      // Assignment related
                    & CopyVariables_ProgramInt_2(s_pc2, s_CL2, t_CL2, s_G, t_G)   //  Copy others global variable
                  )
                  | programInt3(2, s_pc2, t_pc2, s_CL2, t_CL2, s_G, t_G )   // constrain
                )
           )
      )
    )

  | (
         true
       & (exists PrCount t_pc2.
             (     Thread2_0_Backward_AbsLocalKeepG( s_pc1, s_CL1, t_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_2(s_pc2, t_pc2,s_CL2,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread2_0_Backward_AbsLocalKeepG;
//#reset Thread2_0_Forward_AbsLocalKeepG;
#timer;



// ###   #  #  ###   ####   ##   ###          #
//  #    #  #  #  #  #     #  #  #  #        ##
//  #    ####  #  #  ###   #  #  #  #         #
//  #    #  #  ###   #     ####  #  #         #
//  #    #  #  # #   #     #  #  #  #         #
//  #    #  #  #  #  ####  #  #  ###         ###

bool Thread1_0_Forward_AbsLocalKeepG1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread1_0_Forward_AbsLocalKeepG(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G)
 );

mu bool Thread1_0_Backward_AbsLocalKeepG(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(    Thread1_0_Forward_AbsLocalKeepG1( s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G )
&
( false

  // initial configuration (init)
  |  (exists
          Local   t_CL1,
          Local   t_CL2,
          Local   t_CL3.
        (
             Thread2_0_Backward_AbsLocalKeepG( s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G )
        )
          &  s_G.v1 = 0
        &  ContextSwitch_1(s_pc1)
        &  ContextSwitch_2(s_pc2)
     )

//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
         true
      & (exists                  // There exists an internal state that
           PrCount t_pc1,
           Local   t_CL1,
           Global t_G.
           (    (   Thread1_0_Backward_AbsLocalKeepG( t_pc1, t_CL1, s_pc2, s_CL2,s_pc3, s_CL3, t_G )
                )
               &(
                  ( programInt1_1(s_pc1, t_pc1, s_CL1, t_CL1, s_G, t_G)      // Assignment related
                    & CopyVariables_ProgramInt_1(s_pc1, s_CL1, t_CL1, s_G, t_G)   //  Copy others global variable
                  )
                  | programInt3(1, s_pc1, t_pc1, s_CL1, t_CL1, s_G, t_G )   // constrain
                )
           )
      )
    )

  | (

          true
       & (exists PrCount t_pc1.
             (     Thread1_0_Backward_AbsLocalKeepG( t_pc1, s_CL1, s_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_1(s_pc1,t_pc1,s_CL1,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread1_0_Backward_AbsLocalKeepG;
//#reset Thread1_0_Forward_AbsLocalKeepG;
#timer;

//                                                            #
// #         #     #   #   ######  #####                     ##
// #         #     #   #   #       #    #                    ##
// #        ###     # #    #       #    #                   # #
// #        # #      #     ####    #####                    # #
// #       #####     #     #       #  #                    #####
// #       #   #     #     #       #   #                      #
// #####  ##   ##    #     ######  #    #                    ###
//

// ####    ###   #   #  #   #  ####            #
 // #   #  #   #  #   #  #   #   #  #          # #
 // #   #  #   #  #   #  ##  #   #  #         #   #
 // ####   #   #  #   #  # # #   #  #         #   #
 // # #    #   #  #   #  #  ##   #  #         #   #
 // #  #   #   #  #   #  #   #   #  #          # #
 // #   #   ###    ###   #   #  ####            #



// ###   #  #  ###   ####   ##   ###          #
//  #    #  #  #  #  #     #  #  #  #        ##
//  #    ####  #  #  ###   #  #  #  #         #
//  #    #  #  ###   #     ####  #  #         #
//  #    #  #  # #   #     #  #  #  #         #
//  #    #  #  #  #  ####  #  #  ###         ###

bool Thread1_0_Backward_AbsLocalKeepG1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread1_0_Backward_AbsLocalKeepG(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, s_G)
 );

mu bool Thread1_0(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(  Thread1_0_Backward_AbsLocalKeepG1(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G)
&
( false

  // early termination
  | ( exists                   // There exists a state such that
            PrCount    t_pc1,
            Local      t_CL1,
            PrCount    t_pc2,
            Local      t_CL2,
            PrCount    t_pc3,
            Local      t_CL3,
            Global    t_G.
        (   Thread1_0( t_pc1, t_CL1, t_pc2, t_CL2, t_pc3, t_CL3, t_G )    // That state in fixed point and ...
          &    target( 1, t_pc1 )                // target is reached
        )
     )


  // initial configuration (init)
  |  (
           initPC(s_pc1)                 // Initial PC
         & GlobalInit(s_G)           // INIT runs FIRST
     )




//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
         true
      & (exists                  // There exists an internal state that
           PrCount t_pc1,
           Local   t_CL1,
           Global t_G.
           (    (   Thread1_0( t_pc1, t_CL1, s_pc2, s_CL2,s_pc3, s_CL3, t_G )
                )
               // &( t_G.v1=0 | ( t_G.v1=1 & t_CL1.v0=1 ) )   // Start, so when it ends?
               &(
                  (
                    programInt1_1(t_pc1,s_pc1,t_CL1,s_CL1,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_1(t_pc1,t_CL1,s_CL1,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(1, t_pc1, s_pc1, t_CL1, s_CL1, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (

          true
       // & (s_G.v1=0 | ( s_G.v1=1 & s_CL1.v0=1 ) )     // Atomic condition
       & (exists PrCount t_pc1.
             (     Thread1_0( t_pc1, s_CL1, s_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_1(t_pc1,s_pc1,s_CL1,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread1_0;
//#reset Thread1_0_Backward_AbsLocalKeepG;
#timer;




 // #####  #   #  ####   #####    #    ####          ###
 //   #    #   #  #   #  #       # #    #  #        #   #
 //   #    #   #  #   #  #      #   #   #  #            #
 //   #    #####  ####   ####   #   #   #  #          ##
 //   #    #   #  # #    #      #####   #  #         #
 //   #    #   #  #  #   #      #   #   #  #        #
 //   #    #   #  #   #  #####  #   #  ####         #####

bool Thread2_0_Backward_AbsLocalKeepG1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread2_0_Backward_AbsLocalKeepG(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)
 );

mu bool Thread2_0(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable

 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(   Thread2_0_Backward_AbsLocalKeepG1(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G)
&
( false

  // early termination
  | ( exists                   // There exists a state such that
            PrCount    t_pc1,
            Local      t_CL1,
            PrCount    t_pc2,
            Local      t_CL2,
            PrCount    t_pc3,
            Local      t_CL3,
            Global    t_G.
        (   Thread2_0( t_pc1, t_CL1, t_pc2, t_CL2, t_pc3, t_CL3, t_G )    // That state in fixed point and ...
          &    target( 2, t_pc2 )                // target is reached
        )
     )


  // initial configuration (init)
  |  (
           initPC(s_pc2)                 // Initial PC
        &  Thread1_0( s_pc1, s_CL1, s_pc2, s_CL2,s_pc3, s_CL3, s_G )
        &  s_G.v1 = 0
        &  ContextSwitch_1(s_pc1)
     )




//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc2,
           Local   t_CL2,
           Global  t_G.
           (    (   Thread2_0( s_pc1, s_CL1, t_pc2, t_CL2,s_pc3, s_CL3, t_G )
                )
               // &( t_G.v1=0 | ( t_G.v1=1 & t_CL2.v0=1 ) )   // Start, so when it ends?
               &(
                  ( programInt1_2(t_pc2,s_pc2,t_CL2,s_CL2,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_2(t_pc2,t_CL2,s_CL2,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(2, t_pc2, s_pc2, t_CL2, s_CL2, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (
         true
       // & (s_G.v1=0 | ( s_G.v1=1 & s_CL2.v0=1 ) )     // Atomic condition
       & (exists PrCount t_pc2.
             (     Thread2_0( s_pc1, s_CL1, t_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_2(t_pc2,s_pc2,s_CL2,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread2_0;
//#reset Thread2_0_Backward_AbsLocalKeepG;
#timer;


// ###   #  #  ###   ####   ##   ###         ####
//  #    #  #  #  #  #     #  #  #  #           #
//  #    ####  #  #  ###   #  #  #  #         ##
//  #    #  #  ###   #     ####  #  #           #
//  #    #  #  # #   #     #  #  #  #        #  #
//  #    #  #  #  #  ####  #  #  ###          ##


bool Thread3_0_Backward_AbsLocalKeepG1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread3_0_Backward_AbsLocalKeepG(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)
 );

mu bool Thread3_0(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable

 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(   Thread3_0_Backward_AbsLocalKeepG1(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G)
&
( false

  // early termination
  | ( exists                   // There exists a state such that
            PrCount    t_pc1,
            Local      t_CL1,
            PrCount    t_pc2,
            Local      t_CL2,
            PrCount    t_pc3,
            Local      t_CL3,
            Global    t_G.
        (   Thread3_0( t_pc1, t_CL1, t_pc2, t_CL2, t_pc3, t_CL3, t_G )    // That state in fixed point and ...
          &    target( 3, t_pc3 )                // target is reached
        )
     )


  // initial configuration (init)
  |  (
           initPC(s_pc3)                 // Initial PC
        &  Thread2_0( s_pc1, s_CL1, s_pc2, s_CL2,s_pc3, s_CL3, s_G )
        &  s_G.v1 = 0
        &  ContextSwitch_2(s_pc2)
     )




//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc3,
           Local   t_CL3,
           Global  t_G.
           (    (   Thread3_0( s_pc1, s_CL1, s_pc2, s_CL2, t_pc3, t_CL3, t_G )
                )
               // &( t_G.v1=0 | ( t_G.v1=1 & t_CL3.v0=1 ) )   // Start, so when it ends?
               &(
                  ( programInt1_3(t_pc3,s_pc3,t_CL3,s_CL3,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_3(t_pc3,t_CL3,s_CL3,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(3, t_pc3, s_pc3, t_CL3, s_CL3, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (
         true
       // & (s_G.v1=0 | ( s_G.v1=1 & s_CL3.v0=1 ) )     // Atomic condition
       & (exists PrCount t_pc3.
             (     Thread3_0( s_pc1, s_CL1, s_pc2, s_CL2,t_pc3, s_CL3, s_G )
                 & programInt2_3(t_pc3,s_pc3,s_CL3,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread3_0;
//#reset Thread3_0_Backward_AbsLocalKeepG;
#timer;




 // ####    ###   #   #  #   #  ####                   #
 // #   #  #   #  #   #  #   #   #  #                 ##
 // #   #  #   #  #   #  ##  #   #  #                # #
 // ####   #   #  #   #  # # #   #  #                  #
 // # #    #   #  #   #  #  ##   #  #                  #
 // #  #   #   #  #   #  #   #   #  #                  #
 // #   #   ###    ###   #   #  ####                 #####







// ###   #  #  ###   ####   ##   ###          #
//  #    #  #  #  #  #     #  #  #  #        ##
//  #    ####  #  #  ###   #  #  #  #         #
//  #    #  #  ###   #     ####  #  #         #
//  #    #  #  # #   #     #  #  #  #         #
//  #    #  #  #  #  ####  #  #  ###         ###

bool Thread1_1_Backward_AbsLocalKeepG1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
( ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread1_1_Backward_AbsLocalKeepG(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)
) );

mu bool Thread1_1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(   Thread1_1_Backward_AbsLocalKeepG1(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G)
&
( false

  // early termination
  | ( exists                   // There exists a state such that
            PrCount    t_pc1,
            Local      t_CL1,
            PrCount    t_pc2,
            Local      t_CL2,
            PrCount    t_pc3,
            Local      t_CL3,
            Global    t_G.
        (   Thread1_1( t_pc1, t_CL1, t_pc2, t_CL2, t_pc3, t_CL3, t_G )    // That state in fixed point and ...
          &    target( 1, t_pc1 )                // target is reached
        )
     )


  // initial configuration (init)
  |  (
        Thread3_0( s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G )
        &  s_G.v1 = 0
        &  ContextSwitch_3(s_pc3)
     )




//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
         true
      & (exists                  // There exists an internal state that
           PrCount t_pc1,
           Local   t_CL1,
           Global t_G.
           (    (   Thread1_1( t_pc1, t_CL1, s_pc2, s_CL2,s_pc3, s_CL3, t_G )
                )
               // &( t_G.v1=0 | ( t_G.v1=1 & t_CL1.v0=1 ) )   // Start, so when it ends?
               &(
                  ( programInt1_1(t_pc1,s_pc1,t_CL1,s_CL1,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_1(t_pc1,t_CL1,s_CL1,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(1, t_pc1, s_pc1, t_CL1, s_CL1, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (

          true
       // & (s_G.v1=0 | ( s_G.v1=1 & s_CL1.v0=1 ) )     // Atomic condition
       & (exists PrCount t_pc1.
             (     Thread1_1( t_pc1, s_CL1, s_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_1(t_pc1,s_pc1,s_CL1,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread1_1;
//#reset Thread1_1_Backward_AbsLocalKeepG;
#timer;



 // #####  #   #  ####   #####    #    ####          ###
 //   #    #   #  #   #  #       # #    #  #        #   #
 //   #    #   #  #   #  #      #   #   #  #            #
 //   #    #####  ####   ####   #   #   #  #          ##
 //   #    #   #  # #    #      #####   #  #         #
 //   #    #   #  #  #   #      #   #   #  #        #
 //   #    #   #  #   #  #####  #   #  ####         #####


bool Thread2_1_Backward_AbsLocalKeepG1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
( ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread2_1_Backward_AbsLocalKeepG(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)
) );

mu bool Thread2_1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(   Thread2_1_Backward_AbsLocalKeepG1(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G)
&
( false

  // early termination
  | ( exists                   // There exists a state such that
            PrCount    t_pc1,
            Local      t_CL1,
            PrCount    t_pc2,
            Local      t_CL2,
            PrCount    t_pc3,
            Local      t_CL3,
            Global    t_G.
        (   Thread2_1( t_pc1, t_CL1, t_pc2, t_CL2, t_pc3, t_CL3, t_G )    // That state in fixed point and ...
          &    target( 2, t_pc2 )                // target is reached
        )
     )


  // initial configuration (init)
  |  (
        Thread1_1( s_pc1, s_CL1, s_pc2, s_CL2,s_pc3, s_CL3, s_G )
        &  s_G.v1 = 0
        &  ContextSwitch_1(s_pc1)
     )





//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc2,
           Local   t_CL2,
           Global  t_G.
           (    (   Thread2_1( s_pc1, s_CL1, t_pc2, t_CL2,s_pc3, s_CL3, t_G )
                )
               // &( t_G.v1=0 | ( t_G.v1=1 & t_CL2.v0=1 ) )   // Start, so when it ends?
               &(
                  ( programInt1_2(t_pc2,s_pc2,t_CL2,s_CL2,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_2(t_pc2,t_CL2,s_CL2,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(2, t_pc2, s_pc2, t_CL2, s_CL2, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (
         true
       // & (s_G.v1=0 | ( s_G.v1=1 & s_CL2.v0=1 ) )     // Atomic condition
       & (exists PrCount t_pc2.
             (     Thread2_1( s_pc1, s_CL1, t_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_2(t_pc2,s_pc2,s_CL2,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread2_1;
//#reset Thread2_1_Backward_AbsLocalKeepG;
#timer;




// ###   #  #  ###   ####   ##   ###         ####
//  #    #  #  #  #  #     #  #  #  #           #
//  #    ####  #  #  ###   #  #  #  #         ##
//  #    #  #  ###   #     ####  #  #           #
//  #    #  #  # #   #     #  #  #  #        #  #
//  #    #  #  #  #  ####  #  #  ###          ##

bool Thread3_1_Backward_AbsLocalKeepG1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
( ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread3_1_Backward_AbsLocalKeepG(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)
) );

mu bool Thread3_1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                      // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(    Thread3_1_Backward_AbsLocalKeepG1(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G)
&
( false

  // early termination
  | ( exists                   // There exists a state such that
            PrCount    t_pc1,
            Local      t_CL1,
            PrCount    t_pc2,
            Local      t_CL2,
            PrCount    t_pc3,
            Local      t_CL3,
            Global    t_G.
        (   Thread3_1( t_pc1, t_CL1, t_pc2, t_CL2, t_pc3, t_CL3, t_G )    // That state in fixed point and ...
          &    target( 3, t_pc3 )                // target is reached
        )
     )


  // initial configuration (init)
  |  (
        Thread2_1( s_pc1, s_CL1, s_pc2, s_CL2,s_pc3, s_CL3, s_G )
        &  s_G.v1 = 0
        &  ContextSwitch_2(s_pc2)
     )




//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc3,
           Local   t_CL3,
           Global  t_G.
           (    (   Thread3_1( s_pc1, s_CL1, s_pc2, s_CL2, t_pc3, t_CL3, t_G )
                )
               // &( t_G.v1=0 | ( t_G.v1=1 & t_CL3.v0=1 ) )   // Start, so when it ends?
               &(
                  ( programInt1_3(t_pc3,s_pc3,t_CL3,s_CL3,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_3(t_pc3,t_CL3,s_CL3,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(3, t_pc3, s_pc3, t_CL3, s_CL3, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (
         true
       // & (s_G.v1=0 | ( s_G.v1=1 & s_CL3.v0=1 ) )     // Atomic condition
       & (exists PrCount t_pc3.
             (     Thread3_1( s_pc1, s_CL1, s_pc2, s_CL2,t_pc3, s_CL3, s_G )
                 & programInt2_3(t_pc3,s_pc3,s_CL3,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread3_1;
//#reset Thread3_1_Backward_AbsLocalKeepG;
#timer;



 // ####    ###   #   #  #   #  ####                  ###
 // #   #  #   #  #   #  #   #   #  #                #   #
 // #   #  #   #  #   #  ##  #   #  #                    #
 // ####   #   #  #   #  # # #   #  #                  ##
 // # #    #   #  #   #  #  ##   #  #                 #
 // #  #   #   #  #   #  #   #   #  #                #
 // #   #   ###    ###   #   #  ####                 #####




// ###   #  #  ###   ####   ##   ###          #
//  #    #  #  #  #  #     #  #  #  #        ##
//  #    ####  #  #  ###   #  #  #  #         #
//  #    #  #  ###   #     ####  #  #         #
//  #    #  #  # #   #     #  #  #  #         #
//  #    #  #  #  #  ####  #  #  ###         ###

bool Thread1_2_Backward_AbsLocalKeepG1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
( ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread1_2_Backward_AbsLocalKeepG(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)
) );

mu bool Thread1_2(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
  s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(   Thread1_2_Backward_AbsLocalKeepG(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G)
&
( false

  // early termination
  | ( exists                   // There exists a state such that
            PrCount    t_pc1,
            Local      t_CL1,
            PrCount    t_pc2,
            Local      t_CL2,
            PrCount    t_pc3,
            Local      t_CL3,
            Global    t_G.
        (   Thread1_2( t_pc1, t_CL1, t_pc2, t_CL2, t_pc3, t_CL3, t_G )    // That state in fixed point and ...
          &    target( 1, t_pc1 )                // target is reached
        )
     )


  // initial configuration (init)
  |  (
        Thread3_1( s_pc1, s_CL1, s_pc2, s_CL2,s_pc3, s_CL3, s_G )
        &  s_G.v1 = 0
        &  ContextSwitch_3(s_pc3)
     )




//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
         true
      & (exists                  // There exists an internal state that
           PrCount t_pc1,
           Local   t_CL1,
           Global t_G.
           (    (   Thread1_2( t_pc1, t_CL1, s_pc2, s_CL2,s_pc3, s_CL3, t_G )
                )
               // &( t_G.v1=0 | ( t_G.v1=1 & t_CL1.v0=1 ) )   // Start, so when it ends?
               &(
                  ( programInt1_1(t_pc1,s_pc1,t_CL1,s_CL1,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_1(t_pc1,t_CL1,s_CL1,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(1, t_pc1, s_pc1, t_CL1, s_CL1, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (

          true
       // & (s_G.v1=0 | ( s_G.v1=1 & s_CL1.v0=1 ) )     // Atomic condition
       & (exists PrCount t_pc1.
             (     Thread1_2( t_pc1, s_CL1, s_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_1(t_pc1,s_pc1,s_CL1,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread1_2;
//#reset Thread1_2_Backward_AbsLocalKeepG;
#timer;



 // #####  #   #  ####   #####    #    ####          ###
 //   #    #   #  #   #  #       # #    #  #        #   #
 //   #    #   #  #   #  #      #   #   #  #            #
 //   #    #####  ####   ####   #   #   #  #          ##
 //   #    #   #  # #    #      #####   #  #         #
 //   #    #   #  #  #   #      #   #   #  #        #
 //   #    #   #  #   #  #####  #   #  ####         #####


bool Thread2_2_Backward_AbsLocalKeepG1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
( ( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread2_2_Backward_AbsLocalKeepG(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)
) );

mu bool Thread2_2(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable

 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(   Thread2_2_Backward_AbsLocalKeepG1(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G)
&
( false

  // early termination
  | ( exists                   // There exists a state such that
            PrCount    t_pc1,
            Local      t_CL1,
            PrCount    t_pc2,
            Local      t_CL2,
            PrCount    t_pc3,
            Local      t_CL3,
            Global    t_G.
        (   Thread2_2( t_pc1, t_CL1, t_pc2, t_CL2, t_pc3, t_CL3, t_G )    // That state in fixed point and ...
          &    target( 2, t_pc2 )                // target is reached
        )
     )


  // initial configuration (init)
  |  (
        Thread1_2( s_pc1, s_CL1, s_pc2, s_CL2,s_pc3, s_CL3, s_G )
        &  s_G.v1 = 0
        &  ContextSwitch_1(s_pc1)
     )




//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc2,
           Local   t_CL2,
           Global  t_G.
           (    (   Thread2_2( s_pc1, s_CL1, t_pc2, t_CL2,s_pc3, s_CL3, t_G )
                )
               // &( t_G.v1=0 | ( t_G.v1=1 & t_CL2.v0=1 ) )   // Start, so when it ends?
               &(
                  ( programInt1_2(t_pc2,s_pc2,t_CL2,s_CL2,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_2(t_pc2,t_CL2,s_CL2,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(2, t_pc2, s_pc2, t_CL2, s_CL2, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (
         true
       // & (s_G.v1=0 | ( s_G.v1=1 & s_CL2.v0=1 ) )     // Atomic condition
       & (exists PrCount t_pc2.
             (     Thread2_2( s_pc1, s_CL1, t_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_2(t_pc2,s_pc2,s_CL2,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread2_2;
//#reset Thread2_2_Backward_AbsLocalKeepG;
#timer;




// ###   #  #  ###   ####   ##   ###         ####
//  #    #  #  #  #  #     #  #  #  #           #
//  #    ####  #  #  ###   #  #  #  #         ##
//  #    #  #  ###   #     ####  #  #           #
//  #    #  #  # #   #     #  #  #  #        #  #
//  #    #  #  #  #  ####  #  #  ###          ##

bool Thread3_2_Backward_AbsLocalKeepG1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 (( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread3_2_Backward_AbsLocalKeepG(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)
 ));

mu bool Thread3_2(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(   Thread3_2_Backward_AbsLocalKeepG1(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G)
&
( false

  // early termination
  | ( exists                   // There exists a state such that
            PrCount    t_pc1,
            Local      t_CL1,
            PrCount    t_pc2,
            Local      t_CL2,
            PrCount    t_pc3,
            Local      t_CL3,
            Global    t_G.
        (   Thread3_2( t_pc1, t_CL1, t_pc2, t_CL2, t_pc3, t_CL3, t_G )    // That state in fixed point and ...
          &    target( 3, t_pc3 )                // target is reached
        )
     )


  // initial configuration (init)
  |  (
        Thread2_2( s_pc1, s_CL1, s_pc2, s_CL2,s_pc3, s_CL3, s_G )
        &  s_G.v1 = 0
        &  ContextSwitch_2(s_pc2)
     )




//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc3,
           Local   t_CL3,
           Global  t_G.
           (    (   Thread3_2( s_pc1, s_CL1, s_pc2, s_CL2, t_pc3, t_CL3, t_G )
                )
               // &( t_G.v1=0 | ( t_G.v1=1 & t_CL3.v0=1 ) )   // Start, so when it ends?
               &(
                  ( programInt1_3(t_pc3,s_pc3,t_CL3,s_CL3,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_3(t_pc3,t_CL3,s_CL3,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(3, t_pc3, s_pc3, t_CL3, s_CL3, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (
         true
       // & (s_G.v1=0 | ( s_G.v1=1 & s_CL3.v0=1 ) )     // Atomic condition
       & (exists PrCount t_pc3.
             (     Thread3_2( s_pc1, s_CL1, s_pc2, s_CL2,t_pc3, s_CL3, s_G )
                 & programInt2_3(t_pc3,s_pc3,s_CL3,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread3_2;
//#reset Thread3_2_Backward_AbsLocalKeepG;
#timer;



 // ####    ###   #   #  #   #  ####          #####
 // #   #  #   #  #   #  #   #   #  #             #
 // #   #  #   #  #   #  ##  #   #  #            #
 // ####   #   #  #   #  # # #   #  #           ##
 // # #    #   #  #   #  #  ##   #  #             #
 // #  #   #   #  #   #  #   #   #  #         #   #
 // #   #   ###    ###   #   #  ####           ###




// ###   #  #  ###   ####   ##   ###          #
//  #    #  #  #  #  #     #  #  #  #        ##
//  #    ####  #  #  ###   #  #  #  #         #
//  #    #  #  ###   #     ####  #  #         #
//  #    #  #  # #   #     #  #  #  #         #
//  #    #  #  #  #  ####  #  #  ###         ###

bool Thread1_3_Backward_AbsLocalKeepG1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 (( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread1_3_Backward_AbsLocalKeepG(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)
 ));


mu bool Thread1_3(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(   Thread1_3_Backward_AbsLocalKeepG1(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G)
&
( false

  // early termination
  | ( exists                   // There exists a state such that
            PrCount    t_pc1,
            Local      t_CL1,
            PrCount    t_pc2,
            Local      t_CL2,
            PrCount    t_pc3,
            Local      t_CL3,
            Global    t_G.
        (   Thread1_3( t_pc1, t_CL1, t_pc2, t_CL2, t_pc3, t_CL3, t_G )    // That state in fixed point and ...
          &    target( 1, t_pc1 )                // target is reached
        )
     )


  // initial configuration (init)
  |  (
        Thread3_2( s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G )
        &  s_G.v1 = 0
        &  ContextSwitch_3(s_pc3)
     )




//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
         true
      & (exists                  // There exists an internal state that
           PrCount t_pc1,
           Local   t_CL1,
           Global t_G.
           (    (   Thread1_3( t_pc1, t_CL1, s_pc2, s_CL2,s_pc3, s_CL3, t_G )
                )
               // &( t_G.v1=0 | ( t_G.v1=1 & t_CL1.v0=1 ) )   // Start, so when it ends?
               &(
                  ( programInt1_1(t_pc1,s_pc1,t_CL1,s_CL1,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_1(t_pc1,t_CL1,s_CL1,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(1, t_pc1, s_pc1, t_CL1, s_CL1, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (

          true
       // & (s_G.v1=0 | ( s_G.v1=1 & s_CL1.v0=1 ) )     // Atomic condition
       & (exists PrCount t_pc1.
             (     Thread1_3( t_pc1, s_CL1, s_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_1(t_pc1,s_pc1,s_CL1,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread1_3;
//#reset Thread1_3_Backward_AbsLocalKeepG;
#timer;


 // #####  #   #  ####   #####    #    ####          ###
 //   #    #   #  #   #  #       # #    #  #        #   #
 //   #    #   #  #   #  #      #   #   #  #            #
 //   #    #####  ####   ####   #   #   #  #          ##
 //   #    #   #  # #    #      #####   #  #         #
 //   #    #   #  #  #   #      #   #   #  #        #
 //   #    #   #  #   #  #####  #   #  ####         #####

bool Thread2_3_Backward_AbsLocalKeepG1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 (( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread2_3_Backward_AbsLocalKeepG(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)
 ));

mu bool Thread2_3(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable

 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(   Thread2_3_Backward_AbsLocalKeepG1(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G)
&
( false

  // early termination
  | ( exists                   // There exists a state such that
            PrCount    t_pc1,
            Local      t_CL1,
            PrCount    t_pc2,
            Local      t_CL2,
            PrCount    t_pc3,
            Local      t_CL3,
            Global    t_G.
        (   Thread2_3( t_pc1, t_CL1, t_pc2, t_CL2, t_pc3, t_CL3, t_G )    // That state in fixed point and ...
          &    target( 2, t_pc2 )                // target is reached
        )
     )


  // initial configuration (init)
  |  (
        (   exists
             PrCount    t_pc1,
             Local      t_CL1.
          Thread1_3( t_pc1, t_CL1, s_pc2, s_CL2,s_pc3, s_CL3, s_G )
        )
        &  s_G.v1 = 0
        &  ContextSwitch_1(s_pc1)
     )



//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc2,
           Local   t_CL2,
           Global  t_G.
           (    (   Thread2_3( s_pc1, s_CL1, t_pc2, t_CL2,s_pc3, s_CL3, t_G )
                )
               // &( t_G.v1=0 | ( t_G.v1=1 & t_CL2.v0=1 ) )   // Start, so when it ends?
               &(
                  ( programInt1_2(t_pc2,s_pc2,t_CL2,s_CL2,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_2(t_pc2,t_CL2,s_CL2,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(2, t_pc2, s_pc2, t_CL2, s_CL2, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (
         true
       // & (s_G.v1=0 | ( s_G.v1=1 & s_CL2.v0=1 ) )     // Atomic condition
       & (exists PrCount t_pc2.
             (     Thread2_3( s_pc1, s_CL1, t_pc2, s_CL2,s_pc3, s_CL3, s_G )
                 & programInt2_2(t_pc2,s_pc2,s_CL2,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread2_3;
//#reset Thread2_3_Backward_AbsLocalKeepG;
#timer;





// ###   #  #  ###   ####   ##   ###         ####
//  #    #  #  #  #  #     #  #  #  #           #
//  #    ####  #  #  ###   #  #  #  #         ##
//  #    #  #  ###   #     ####  #  #           #
//  #    #  #  # #   #     #  #  #  #        #  #
//  #    #  #  #  #  ####  #  #  ###          ##

bool  Thread3_3_Backward_AbsLocalKeepG1(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable
 Global     s_G                     // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
 (( exists
     Local      t_CL1,
     Local      t_CL2,
     Local      t_CL3,
     Global     t_G.
     Thread3_3_Backward_AbsLocalKeepG(s_pc1, t_CL1, s_pc2, t_CL2, s_pc3, t_CL3, t_G)
 ));

mu bool Thread3_3(
 PrCount    s_pc1,                  // Program counter
 Local      s_CL1,                  // Local variable
 PrCount    s_pc2,                  // Program counter
 Local      s_CL2,                  // Local variable
 PrCount    s_pc3,                  // Program counter
 Local      s_CL3,                  // Local variable

 Global     s_G                    // Global variable
)
 s_pc1    <  s_CL1,
 s_CL1    <  s_pc2,
 s_pc2    <  s_CL2,
 s_CL2    <  s_pc3,
 s_pc3    <  s_CL3,
 s_CL3    <  s_G
(   Thread3_3_Backward_AbsLocalKeepG1(s_pc1, s_CL1, s_pc2, s_CL2, s_pc3, s_CL3, s_G)
&
( false

  // early termination
  | ( exists                   // There exists a state such that
            PrCount    t_pc1,
            Local      t_CL1,
            PrCount    t_pc2,
            Local      t_CL2,
            PrCount    t_pc3,
            Local      t_CL3,
            Global    t_G.
        (   Thread3_3( t_pc1, t_CL1, t_pc2, t_CL2, t_pc3, t_CL3, t_G )    // That state in fixed point and ...
          &    target( 3, t_pc3 )                // target is reached
        )
     )


  // initial configuration (init)
  | (
      (

        exists
            PrCount    t_pc1,
            Local      t_CL1,
            PrCount    t_pc2,
            Local      t_CL2.

        Thread2_3( t_pc1, t_CL1, t_pc2, t_CL2, s_pc3, s_CL3, s_G )
      )
      &  s_G.v1 = 0
        &  ContextSwitch_2(s_pc2)
    )



//*********************************************************************************/
// forward propagation on internal transitions
//*********************************************************************************/

  |  (
      true
      & (exists                  // There exists an internal state that
           PrCount t_pc3,
           Local   t_CL3,
           Global  t_G.
           (    (   Thread3_3( s_pc1, s_CL1, s_pc2, s_CL2, t_pc3, t_CL3, t_G )
                )
               // &( t_G.v1=0 | ( t_G.v1=1 & t_CL3.v0=1 ) )   // Start, so when it ends?
               &(
                  ( programInt1_3(t_pc3,s_pc3,t_CL3,s_CL3,t_G,s_G)      // Assignment related
                    & CopyVariables_ProgramInt_3(t_pc3,t_CL3,s_CL3,t_G,s_G)   //  Copy others global variable
                  )
                  | programInt3(3, t_pc3, s_pc3, t_CL3, s_CL3, t_G, s_G )   // constrain
                )
           )
      )
    )

  | (
         true
       // & (s_G.v1=0 | ( s_G.v1=1 & s_CL3.v0=1 ) )     // Atomic condition
       & (exists PrCount t_pc3.
             (     Thread3_3( s_pc1, s_CL1, s_pc2, s_CL2,t_pc3, s_CL3, s_G )
                 & programInt2_3(t_pc3,s_pc3,s_CL3,s_G)    // Control flow statement
             )
         )
    )
)
);
#size Thread3_3;
//#reset Thread3_3_Backward_AbsLocalKeepG;
#timer;


/******************************************************************************************************/
//                                       Reachabibility check                                         *
/******************************************************************************************************/


(
    ( exists
            PrCount t_pc,
            Local   t_CL,
            Global  t_G.
        (   Init_Reach( t_pc, t_CL, t_G )
          & target( 0, t_pc)   // ??????????
        )
     )

   | ( exists                   // There exists a state such that
            PrCount    t_pc1,
            Local      t_CL1,
            PrCount    t_pc2,
            Local      t_CL2,
            PrCount    t_pc3,
            Local      t_CL3,
            Global    t_G.
        (
        (
                Thread1_3( t_pc1, t_CL1, t_pc2, t_CL2, t_pc3, t_CL3, t_G )    // That state in fixed point and ...
          &    target( 1, t_pc1 )
        )
        | (
                Thread2_3( t_pc1, t_CL1, t_pc2, t_CL2, t_pc3, t_CL3, t_G )    // That state in fixed point and ...
          &    target( 2, t_pc2 )
        )
        | (
                Thread3_3( t_pc1, t_CL1, t_pc2, t_CL2, t_pc3, t_CL3, t_G )    // That state in fixed point and ...
          &    target( 3, t_pc3 )
        )

        )
     )

);

#timer stop;

