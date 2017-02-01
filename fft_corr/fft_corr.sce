
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
 
//weighting factor
u = n*3;
w = n*3;
U = ones(u/4+1,w/4+1);
W = zeros(u/4,w/4);
[uu ww] = size(W);
W((uu/3+1):(uu/3+1)+(uu/3-1),(ww/3+1):(ww/3+1)+(ww/3-1)) = 1;
WF = conv2(W,U);
[uuu www] = size(WF);
WF_n = [zeros(uu,u) ; zeros(uuu,uu) WF zeros(uuu,uu) ; zeros(uu,u)];
WF_nn = mat2gray(WF_n);

for tt = 0:250:2500
    for k = gg+tt:2:ll+tt
        kk = msprintf("%1.0f",k);
        Z = msprintf('%04d',k); //Assigning image filename
        Y = msprintf('%04d',k+2);
        F = A+'\image-'+Z+'.png'; 
        G = A+'\image-'+Y+'.png';
        I = imread(F); //Reading image file to matrix
        //I = rgb2gray(I); //RGB 2 Grayscale
        I = double(I); //Assigning double precision to image matrix
        II = imread(G);
        //II = rgb2gray(II);
        II = double(II);


        for a=250:n:650 //loop row matrix element
            for b=50:n:450 //loop column matrix element
                I_a = I(a:a+(n-1),b:b+(n-1)); //1st image matrix
                II_a = II(a-n:a-1+2*n,b-n:b-1+2*n); //2nd image matrix
                I_b = [zeros(n,3*n) ; [zeros(n,n) I_a zeros(n,n)]; zeros(n,3*n)];

                FI_b = fft2(I_b);
                FII_a = conj(fft2(II_a));

                Fconv = FI_b.*(FII_a);
                IFconv = fft2(Fconv);

                RFconv = abs(fftshift(IFconv));

                III = mat2gray(RFconv);

                III_w = III.*WF_nn;
                
                e = ((a-250)/n)+1;
                f = ((b-50)/n)+1;
                
                ee = msprintf("%1.0f",e);
                ff = msprintf("%1.0f",f);

                mkdir(outputDir + '\' + 'Matrix_korelasi'+ '\' + kk);//Creating correlation matrix folder
                filepath1 = [outputDir + '\' + 'Matrix_korelasi'+ '\' + kk + '\' + ee + '_' + ff + '.txt'];
                fprintfMat (filepath1,III_w,"%5.4f"); //Saving correlation matrix

                clear II_c; //clearing memory
                clear RFconv;
                clear IFconv;
                clear Fconv;
                clear FI_b;
                clear FII_a;
                clear I_b;
                clear I_a;
                clear II_a;
                clear III_w;
                clear III;
            end
        end
        disp(kk);
    end
end
