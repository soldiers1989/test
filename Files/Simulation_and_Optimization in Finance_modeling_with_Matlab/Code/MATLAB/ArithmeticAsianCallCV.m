function CAA = ArithmeticAsianCallCV(initPrice,K,r,T,sigma,q,numSteps,numPrelim,numPaths)
%function for evaluating the price of an arithmetic Asian option using the price of a geometric %Asian option as a control variate
%initPrice is the initial price, K is the strike price
%r is the annual interest rate, T is the time to maturity, sigma is the
%annual volatility
%q is the continuous dividend yield
%numSteps is the number of evaluation steps between time 0 and maturity
%numPrelim is the number of preliminary trials to run for estimating the coefficient b
%numPaths is the number of scenarios to generate for the actual evaluation of the arithmetic Asian option price.

%Copyright � 2010 John Wiley & Sons, Inc., Dessislava A. Pachamanova, and Frank J. Fabozzi.
%All rights reserved.

%Model files and code may be copied and used only by owners of the book Simulation and Optimization in Finance: Modeling with MATLAB, @RISK or VBA, by Dessislava A. Pachamanova and Frank J. Fabozzi, Hoboken, NJ: John Wiley & Sons, 2010 and only for their own personal use.  Copying and/or use for any other purpose or by any other person is prohibited. Requests for permission for other uses should be addressed to the Permissions Department, John Wiley & Sons, Inc., 111 River Street, Hoboken, NJ 07030, (201) 748-6011, fax (201) 748-6008, or online at http://www.wiley.com/go/permissions.

%While the authors and publisher have used all reasonable efforts in creating the work, the model files and the code, they make no representations or warranties with respect to the accuracy or completeness of the contents thereof, and specifically disclaim any implied warranties of merchantability or fitness for a particular purpose.  No warranty may be created or extended by sales representatives or written sales materials.  The advice and strategies contained herein may not be suitable for a particular party�s situation.  Users should consult with a professional where appropriate.  

%LIMITATION OF LIABILITY

%IN NO EVENT SHALL THE AUTHOR OR THE PUBLISHER BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THE WORK, THE MODEL FILES OR THE CODE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

geomAsianPrice = GeometricAsianCall(initPrice,K,r,T,sigma,q,numSteps);

%run preliminary simulation and estimate b
geomAsianPayoffs = zeros(numPrelim,1);
arithmAsianPayoffs = zeros(numPrelim,1);

prelimPaths = GRWPaths(initPrice,r-q,sigma,T,numSteps,numPrelim);

for iPrelim = 1:numPrelim
    arithmAsianPayoffs(iPrelim) = exp(-r*T)*max(mean(prelimPaths(2:(numSteps+1),iPrelim))- K,0);
    geomAsianPayoffs(iPrelim) =  exp(-r*T)*max(prod(prelimPaths(2:(numSteps+1),iPrelim))^(1/numSteps)- K,0);
end

covMx = cov(arithmAsianPayoffs,geomAsianPayoffs);
b = covMx(2,1)/var(geomAsianPayoffs);

%run actual simulation for arithmetic Asian option
geomAsianPayoff = 0;
arithmAsianPayoff = 0;
paths = GRWPaths(initPrice,r,sigma,T,numSteps,numPaths);
estimatesCV = zeros(numPaths,1);
for iPath = 1:numPaths
    arithmAsianPayoff = exp(-r*T)*max(mean(paths(2:(numSteps+1),iPath))- K,0);
    geomAsianPayoff =  exp(-r*T)*max(prod(paths(2:(numSteps+1),iPath))^(1/numSteps)- K,0);
    estimatesCV(iPath) = arithmAsianPayoff - b*(geomAsianPayoff - geomAsianPrice);
end

%estimate price of arithmetic Asian option
CAA = mean(estimatesCV);




