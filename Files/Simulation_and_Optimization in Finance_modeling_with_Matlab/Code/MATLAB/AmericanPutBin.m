function AmPutPrice = AmericanPutBin(initPrice, K, T, r, sigma, numSteps)

%Copyright � 2010 John Wiley & Sons, Inc., Dessislava A. Pachamanova, and Frank J. Fabozzi.
%All rights reserved.

%Model files and code may be copied and used only by owners of the book Simulation and Optimization in Finance: Modeling with MATLAB, @RISK or VBA, by Dessislava A. Pachamanova and Frank J. Fabozzi, Hoboken, NJ: John Wiley & Sons, 2010 and only for their own personal use.  Copying and/or use for any other purpose or by any other person is prohibited. Requests for permission for other uses should be addressed to the Permissions Department, John Wiley & Sons, Inc., 111 River Street, Hoboken, NJ 07030, (201) 748-6011, fax (201) 748-6008, or online at http://www.wiley.com/go/permissions.

%While the authors and publisher have used all reasonable efforts in creating the work, the model files and the code, they make no representations or warranties with respect to the accuracy or completeness of the contents thereof, and specifically disclaim any implied warranties of merchantability or fitness for a particular purpose.  No warranty may be created or extended by sales representatives or written sales materials.  The advice and strategies contained herein may not be suitable for a particular party�s situation.  Users should consult with a professional where appropriate.  

%LIMITATION OF LIABILITY

%IN NO EVENT SHALL THE AUTHOR OR THE PUBLISHER BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THE WORK, THE MODEL FILES OR THE CODE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

%initPrice is the current stock price
%K is the exercise price
%T is the time to maturity
%r is the risk-free interest rate
%sigma is the volatility of the stock
%numSteps is the number of time periods to consider for pricing

deltaT = T / numSteps;
up = exp(sigma * sqrt(deltaT));
down = exp(-sigma * sqrt(deltaT));

%pUp and pDown are the probabilities of the stock price going up and down, respectively
pUp = (exp(r * deltaT) - down)/(up - down);
pDown = 1 - pUp;

%df is the discount factor
df = exp(-r * deltaT);

OptionValueNext = zeros(1,numSteps + 1); %will store payoffs at time t+1
OptionValueCurrent = zeros(1,numSteps); %will store payoffs at time t

%Compute payoffs at the last time period
for iStep = 0:(numSteps)
    iState = iStep + 1;
    OptionValueNext(1,iState) = max(K - initPrice * (up^iStep) * (down^(numSteps - iStep)), 0);
end

%Go backwards down the tree
for iStep = (numSteps - 1):-1:0
    for iIndex = 0:iStep
        iState = iIndex + 1;
        OptionValueCurrent(iState) = ...
            max(K - initPrice * (up ^ iIndex) * (down ^ (iStep - iIndex)), ...
            df * (pUp * OptionValueNext(iState + 1) + pDown * OptionValueNext(iState)));
    end
    for iIndex = 0:iStep
        iState = iIndex + 1;
        OptionValueNext(iState) = OptionValueCurrent(iState);
    end
end

AmPutPrice = OptionValueCurrent(1);

end

