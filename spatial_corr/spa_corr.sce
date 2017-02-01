//**************************************************************************/

//
//Pre-processing and Spatial Cross Correlation for Micro-bubble size estimation
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
//bubble diplacement using spatial cross correlation algorithm

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
n = evstr(x_dialog('Please enter size of correlation window: ','16'));


f = evstr(x_dialog('Please enter 1st image number: ','51'));
l = evstr(x_dialog('Please enter last image number: ','52'));

for k = f//:2:l //loop image sequence

//Image Pre-Processing Process

        Z = msprintf('%04d',k); //Assigning image filename
        Y = msprintf('%04d',k+1);
        F = A+'\image-'+Z+'.png'; 
        G = A+'\image-'+Y+'.png';
        I = imread(F); //Reading image file to matrix
        //I = rgb2gray(I); //RGB 2 Grayscale
        I = double(I); //Assigning double precision to image matrix
        II = imread(G);
        //II = rgb2gray(II);
        II = double(II);



        II_b = zeros(3*n-2,3*n-2); //Creating all zeros matrix for zero patching
        
                    kk = msprintf("%1.0f",k);

        for a=232//200:n:776 //loop row matrix element
            for b=100//100:n:676 //loop column matrix element
                    I_a = I(a:a+(n-1),b:b+(n-1)); //1st image matrix
                    II_a = II(a:a+(n-1),b:b+(n-1)); //2nd image matrix
                    II_b = [zeros(n-1,3*n-2) ; [zeros(n,n-1) II_a zeros(n,n-1)]; zeros(n-1,3*n-2)];
                for c =1:2*n-1 //loop scanning interrogation window
                    for d = 1:2*n-1
                    II_c = II_b(c:c+n-1,d:d+n-1); //matrix to be correlated according to size of correlation window
                    III(c,d) = sum(I_a.*II_c); //Spatial Cross-correlation
                    end
                end
                e = ((a-200)/n)+1;
                f = ((b-100)/n)+1;
                

//loop processing correlation matrix

            if max(III) == 0 then 
                    O = [n n];
                    V(e, f)= sqrt((O(1,1)-n)^2 + (O(1,2)-n)^2);
                else
                P = find(III == max(III)); //finding maximum element from correlation matrix
                O = ind2sub(size(III),P); //extracting index(row,column) of the maximum matrix
                O = round(mean(O,1));
                V(e, f)= sqrt((O(1,1)-n)^2 + (O(1,2)-n)^2); //calculating displacement magnitude
            end
                Ox(e, f) = O(1,2)-n; //calculating displacement vector y
                Oy(e, f) = O(1,1)-n; //calculating displacement vector x

                    ee = msprintf("%1.0f",e);
                    ff = msprintf("%1.0f",f);
                    
                mkdir(outputDir + '\' + 'Matrix_korelasi'+ '\' + kk);//Creating correlation matrix folder
                filepath1 = [outputDir + '\' + 'Matrix_korelasi'+ '\' + kk + '\' + ee + '_' + ff + '.txt'];
                fprintfMat (filepath1,III,"%5.2f"); //Saving correlation matrix

                clear II_c; //clearing memory
                clear III;
                clear II_a;
            end
        end

//loop processing displacement vector

                                //Ox = matrix(Ox,1, -1);
                                //Oy = matrix(Oy,1, -1);
                                Ox = matrix(Ox,1, -1);
                                Oy = matrix(Oy,1, -1);
                                Oxy = [];
                                Oxy(1,:)= Ox;
                                Oxy(2,:)= Oy;
                                

                filepath2 = [outputDir + '\' + 'Matrix_vector'+ '\' + kk + '.txt'];
                mkdir(outputDir + '\' + 'Matrix_vector'); 
                fprintfMat (filepath2,Oxy,"%5.2f"); //Saving displacement vector matrix
                
VV = matrix(V,1, -1);
VV(VV==0) = [];

filepath3 = [outputDir + '\' + 'Matrix_magnitude'+ '\' + kk + '.txt'];
mkdir(outputDir + '\' + 'Matrix_magnitude'); 
fprintfMat (filepath3,VV,"%5.2f"); //saving displacement magnitude matrix

clear V; //clearing memory
clear VV;
clear Ox;
clear Oy;
clear Oxy;
disp(k);
end
        
