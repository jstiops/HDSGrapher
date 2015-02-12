$ T i t l e   =   " T o t a l   R e a d s   V S   W r i t e s   P e r c e n t a g e "  
 $ A u t h o r   =   " J e f f r e y   S t r i k "  
 $ P l u g i n V e r s i o n   =   2 . 0  
  
  
 #   S t a r t   o f   S e t t i n g s  
 #   E n d   o f   S e t t i n g s  
  
 # s e t t i n g s   f o r   p l u g i n s  
 $ L i n e T y p e   =   " S t a c k e d A r e a 1 0 0 "  
 $ A x i s Y T i t l e   =   " % "  
 $ A x i s X T i t l e   =   " T i m e "  
 $ C h a r t T i t l e   =   " R e a d   V S   W r i t e   I O P s "  
 $ X P r o p e r t y N a m e   =   " T i m e "  
 # s e t t i n g s   f o r   p l u g i n s  
  
  
 F u n c t i o n   R v s W P o r t R e a d R a t e   {  
          
         $ c t l 0 v a l u e s   =   G e t - C o n t e n t   - p a t h   $ C s v P a t h " \ C T L 0 _ P o r t _ R e a d R a t e . c s v "   |   S e l e c t - O b j e c t   - S k i p   5   |   C o n v e r t F r o m - C s v   - D e l i m i t e r   " , "  
         $ c t l 1 v a l u e s   =   G e t - C o n t e n t   - p a t h   $ C s v P a t h " \ C T L 1 _ P o r t _ R e a d R a t e . c s v "   |   S e l e c t - O b j e c t   - S k i p   5   |   C o n v e r t F r o m - C s v   - D e l i m i t e r   " , "  
  
         # g e t   t h e   p o r t s   u s e d   o n   t h i s   s y s t e m  
         $ P o r t s O b j   =   $ c t l 0 v a l u e s   |   g e t - m e m b e r   |   W h e r e - O b j e c t   { $ _ . N a m e   - e q   " A "   - o r   $ _ . N a m e   - e q   " B "   - o r   $ _ . N a m e   - e q   " C "   - o r   $ _ . N a m e   - e q   " D "   - o r   $ _ . N a m e   - e q   " E "   - o r   $ _ . N a m e   - e q   " F " }  
  
         # b u i l d   o b j e c t s   w i t h   s u m m e d   t o t a l   p r o p e r t y   a d d e d   t o   i t   f o r   C o n t r o l l e r 0   v a l u e s  
         $ o b j C o l l e c t i o n C 0   =   @ ( )  
         $ c t l 0 V a l u e s   |   F o r E a c h - O b j e c t   {  
                 $ t o t a l I O R a t e   =   0  
                 $ c u r r e n t O b j   =   $ _  
                         $ P o r t s O b j   |   F o r E a c h - O b j e c t   {  
                  
                                 $ t o t a l I O R a t e   =   $ t o t a l I O R a t e   +     [ i n t ] ( $ c u r r e n t O b j   | S e l e c t - O b j e c t   - E x p a n d P r o p e r t y   ( $ _ . N a m e ) )  
  
                         }  
                 $ _   | A d d - M e m b e r   N o t e P r o p e r t y   T o t a l I O R a t e   $ t o t a l I O R a t e  
                 $ o b j C o l l e c t i o n C 0   + =   $ _  
         }  
  
         # b u i l d   o b j e c t s   w i t h   s u m m e d   t o t a l   p r o p e r t y   a d d e d   t o   i t   f o r   C o n t r o l l e r 1   v a l u e s  
         $ o b j C o l l e c t i o n C 1   =   @ ( )  
         $ c t l 1 V a l u e s   |   F o r E a c h - O b j e c t   {  
                 $ t o t a l I O R a t e   =   0  
                 $ c u r r e n t O b j   =   $ _  
                         $ P o r t s O b j   |   F o r E a c h - O b j e c t   {  
                  
                                 $ t o t a l I O R a t e   =   $ t o t a l I O R a t e   +     [ i n t ] ( $ c u r r e n t O b j   | S e l e c t - O b j e c t   - E x p a n d P r o p e r t y   ( $ _ . N a m e ) )  
  
                         }  
                 $ _   | A d d - M e m b e r   N o t e P r o p e r t y   T o t a l I O R a t e   $ t o t a l I O R a t e  
                 $ o b j C o l l e c t i o n C 1   + =   $ _  
         }  
  
         # b u i l d   o b j e c t s   w i t h   c a l c u l a t e d   I O R a t e .   T h i s   i s   t h e   S u m   o f   a l l   I O P s   o f   a l l   p o r t s   f r o m   b o t h   c o n t r o l l e r s  
         $ o b j C o l l e c t i o n T o t a l   =   @ ( )  
         $ c o u n t e r   =   0  
         $ o b j C o l l e c t i o n C 0   |   F o r E a c h - O b j e c t   {  
  
                 $ t o t a l I O R a t e   =   [ i n t ] $ _ . T o t a l I O R a t e   +   [ i n t ] $ o b j C o l l e c t i o n C 1 [ $ c o u n t e r ] . T o t a l I O R a t e  
                  
                 $ p r o p s   =   [ o r d e r e d ] @ { T i m e   =   $ _ . T i m e  
                                                         R e a d R a t e   =     $ t o t a l I O R a t e  
                                                 }  
                 $ o b j =   N e w - O b j e c t   - T y p e N a m e   P S O b j e c t   - P r o p e r t y   $ p r o p s  
                 $ o b j C o l l e c t i o n T o t a l   + =   $ o b j  
  
         }  
    
         $ o b j C o l l e c t i o n T o t a l  
  
 }  
  
 F u n c t i o n   R v s W P o r t W r i t e R a t e   {  
          
         $ c t l 0 v a l u e s   =   G e t - C o n t e n t   - p a t h   $ C s v P a t h " \ C T L 0 _ P o r t _ W r i t e R a t e . c s v "   |   S e l e c t - O b j e c t   - S k i p   5   |   C o n v e r t F r o m - C s v   - D e l i m i t e r   " , "  
         $ c t l 1 v a l u e s   =   G e t - C o n t e n t   - p a t h   $ C s v P a t h " \ C T L 1 _ P o r t _ W r i t e R a t e . c s v "   |   S e l e c t - O b j e c t   - S k i p   5   |   C o n v e r t F r o m - C s v   - D e l i m i t e r   " , "  
  
         # g e t   t h e   p o r t s   u s e d   o n   t h i s   s y s t e m  
         $ P o r t s O b j   =   $ c t l 0 v a l u e s   |   g e t - m e m b e r   |   W h e r e - O b j e c t   { $ _ . N a m e   - e q   " A "   - o r   $ _ . N a m e   - e q   " B "   - o r   $ _ . N a m e   - e q   " C "   - o r   $ _ . N a m e   - e q   " D "   - o r   $ _ . N a m e   - e q   " E "   - o r   $ _ . N a m e   - e q   " F " }  
  
         # b u i l d   o b j e c t s   w i t h   s u m m e d   t o t a l   p r o p e r t y   a d d e d   t o   i t   f o r   C o n t r o l l e r 0   v a l u e s  
         $ o b j C o l l e c t i o n C 0   =   @ ( )  
         $ c t l 0 V a l u e s   |   F o r E a c h - O b j e c t   {  
                 $ t o t a l I O R a t e   =   0  
                 $ c u r r e n t O b j   =   $ _  
                         $ P o r t s O b j   |   F o r E a c h - O b j e c t   {  
                  
                                 $ t o t a l I O R a t e   =   $ t o t a l I O R a t e   +     [ i n t ] ( $ c u r r e n t O b j   | S e l e c t - O b j e c t   - E x p a n d P r o p e r t y   ( $ _ . N a m e ) )  
  
                         }  
                 $ _   | A d d - M e m b e r   N o t e P r o p e r t y   T o t a l I O R a t e   $ t o t a l I O R a t e  
                 $ o b j C o l l e c t i o n C 0   + =   $ _  
         }  
  
         # b u i l d   o b j e c t s   w i t h   s u m m e d   t o t a l   p r o p e r t y   a d d e d   t o   i t   f o r   C o n t r o l l e r 1   v a l u e s  
         $ o b j C o l l e c t i o n C 1   =   @ ( )  
         $ c t l 1 V a l u e s   |   F o r E a c h - O b j e c t   {  
                 $ t o t a l I O R a t e   =   0  
                 $ c u r r e n t O b j   =   $ _  
                         $ P o r t s O b j   |   F o r E a c h - O b j e c t   {  
                  
                                 $ t o t a l I O R a t e   =   $ t o t a l I O R a t e   +     [ i n t ] ( $ c u r r e n t O b j   | S e l e c t - O b j e c t   - E x p a n d P r o p e r t y   ( $ _ . N a m e ) )  
  
                         }  
                 $ _   | A d d - M e m b e r   N o t e P r o p e r t y   T o t a l I O R a t e   $ t o t a l I O R a t e  
                 $ o b j C o l l e c t i o n C 1   + =   $ _  
         }  
  
         # b u i l d   o b j e c t s   w i t h   c a l c u l a t e d   I O R a t e .   T h i s   i s   t h e   S u m   o f   a l l   I O P s   o f   a l l   p o r t s   f r o m   b o t h   c o n t r o l l e r s  
         $ o b j C o l l e c t i o n T o t a l   =   @ ( )  
         $ c o u n t e r   =   0  
         $ o b j C o l l e c t i o n C 0   |   F o r E a c h - O b j e c t   {  
  
                 $ t o t a l I O R a t e   =   [ i n t ] $ _ . T o t a l I O R a t e   +   [ i n t ] $ o b j C o l l e c t i o n C 1 [ $ c o u n t e r ] . T o t a l I O R a t e  
                  
                 $ p r o p s   =   [ o r d e r e d ] @ { T i m e   =   $ _ . T i m e  
                                                         W r i t e R a t e   =     $ t o t a l I O R a t e  
                                                 }  
                 $ o b j =   N e w - O b j e c t   - T y p e N a m e   P S O b j e c t   - P r o p e r t y   $ p r o p s  
                 $ o b j C o l l e c t i o n T o t a l   + =   $ o b j  
  
         }  
    
         $ o b j C o l l e c t i o n T o t a l  
  
 }  
  
  
  
 $ R e a d V S W r i t e C h a r t   =   N e w - P S G r a p h C h a r t   - C h a r t T i t l e   $ C h a r t T i t l e   - A x i s X T i t l e   $ A x i s X T i t l e   - A x i s Y T i t l e   $ A x i s Y T i t l e   - A x i s X I n t e r v a l   $ A x i s X I n t e r v a l  
 R v s W P o r t R e a d R a t e   |   A d d - P S G r a p h S e r i e   - C h a r t N a m e   " R e a d V S W r i t e C h a r t "   - N a m e   " R e a d s "   - Y P r o p e r t y N a m e   " R e a d R a t e "   - X P r o p e r t y N a m e   $ X P r o p e r t y N a m e   - T y p e   $ L i n e T y p e  
 R v s W P o r t W r i t e R a t e   |   A d d - P S G r a p h S e r i e   - C h a r t N a m e   " R e a d V S W r i t e C h a r t "   - N a m e   " W r i t e s "   - Y P r o p e r t y N a m e   " W r i t e R a t e "   - X P r o p e r t y N a m e   $ X P r o p e r t y N a m e   - T y p e   $ L i n e T y p e  
 $ R e a d V S W r i t e C h a r t . S a v e C h a r t ( " $ G r a p h O u t p u t P a t h \ R e a d s V S W r i t e s P e r c e n t a g e . p n g " )  
 
