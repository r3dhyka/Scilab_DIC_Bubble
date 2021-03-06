//**************************************************************************/

//
//FFT Cross Correlation for Micro-bubble size estimation
//Last updated July 25, 2016
//
//
//
// * Copyright (c)2016 Grace G. Redhyka, ggredhyka@gmail.com
// *
// * Permission is hereby granted, free of charge, to any person obtaining
// * a copy of this software and associated documentation files (the
// * "Software"), to deal in the Software without restriction, including
// * without limitation the rights to use, copy, modify, merge, publish,
// * distribute, sublicense, and/or sell copies of the Software, and to
// * permit persons to whom the Software is furnished to do so, subject to
// * the following conditions:
// *
// * 1. The above copyright notice and this permission notice shall be
// * included in all copies or substantial portions of the Software.
// *
// * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
// * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
// * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// * SOFTWARE.
//
//
//This function read scattering image, perform pre-processing, and obtain the
//bubble diplacement using FFT cross correlation algorithm

//**************************************************************************/

stacksize max; //Allocating maximum memory

mmm = messagebox('Please enter the input folder', 'Input Folder','modal');
if mmm == 1 then
    A = uigetdir(); //Assigning folder containing image sequence
else 
    A = [];
    end
mm = messagebox('Please enter the output folder', 'Output Folder','modal');
if mm == 1 then
    outputDir = uigetdir(); //Assigning output folder
else
    outputDir = [];
    end
//Assigning size of correlation window
n = evstr(x_dialog('Please enter size of correlation window: ','32'));

gg = evstr(x_dialog('Please enter 1st image number: ','500'));
ll = evstr(x_dialog('Please enter 2nd image number: ','508'));

for tt = 0:250:2500
    for a=250:n:650 //loop row matrix element
        for b=50:n:450 //loop column matrix element
            
            e = ((a-250)/n)+1;
            f = ((b-50)/n)+1;
            
            ee = msprintf("%1.0f",e);
            ff = msprintf("%1.0f",f);
            
            III_sum = [];

                for k = gg+tt:2:ll+tt
                    kk = msprintf("%1.0f",k);
                    
                    filepath1 = [A + '/' + 'Matrix_korelasi'+ '/' + kk + '/' + ee + '_' + ff + '.txt'];
                    III_w = fscanfMat(filepath1);
                    III_sum = III_w + III_sum;
                end
                III_avg = III_sum/5;

                jj = gg + tt;
                pp = msprintf("%1.0f",jj);
                mkdir(outputDir + '/' + 'Matrix_korelasi_avg'+ '/' + pp);//Creating correlation matrix folder
                filepath2 = [outputDir + '/' + 'Matrix_korelasi_avg'+ '/' + pp + '/' + ee + '_' + ff + '.txt'];
                fprintfMat (filepath2,III_avg,"%5.4f"); //Saving correlation matrix

                if max(III_avg) == 0 then 
                    O = [n n];
                    V(e, f)= sqrt((O(1,1)-n)^2 + (O(1,2)-n)^2);
                else
                P = find(III_avg == max(III_avg)); //finding maximum element from correlation matrix
                O = ind2sub(size(III_avg),P); //extracting index(row,column) of the maximum matrix
                O = round(mean(O,1));
                Ox(e, f) = O(1,2)-(1.5*n+1); //calculating displacement vector x
                Oy(e, f) = (1.5*n+1)- O(1,1); //calculating displacement vector y
                V(e, f)= sqrt((Ox(e, f))^2 + (Oy(e, f))^2); //calculating displacement magnitude
                end

                clear III_w;
                clear III_avg;
                clear III_sum;
            
            filepath3 = [outputDir + '/' + 'Matrix_vector'+ '/' + pp + '_x' + '.txt'];
            filepath4 = [outputDir + '/' + 'Matrix_vector'+ '/' + pp + '_y' + '.txt'];
            mkdir(outputDir + '/' + 'Matrix_vector'); 
            fprintfMat (filepath3,Ox,"%5.4f");
            fprintfMat (filepath4,Oy,"%5.4f"); //Saving displacement vector matrix

            filepath5 = [outputDir + '/' + 'Matrix_magnitude'+ '/' + pp + '.txt'];
            mkdir(outputDir + '/' + 'Matrix_magnitude'); 
            fprintfMat (filepath5,V,"%5.4f"); //saving displacement magnitude matrix



            clear O;
            clear P;

        end
    end
    clear Ox;
    clear Oy;
    clear V;
end
        
