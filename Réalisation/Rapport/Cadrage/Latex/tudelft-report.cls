% This template aims to simplify and improve the (Xe)LaTeX template provided
% by the TU Delft. Original template by TU Delft. Rewritten template by Daan
% Zwaneveld (https://dzwaneveld.github.io)
%
% This template by Daan Zwaneveld is licensed under CC BY-NC 4.0. To view a
% copy of this license, visit https://creativecommons.org/licenses/by-nc/4.0/.
% No attribution is required in PDF outputs created using this template.

%% ----------------------------------------------------------------------
%%    Setting up the class, main packages and basic definitions
%% ----------------------------------------------------------------------
% Couleurs
\usepackage{xcolor}
\definecolor{amsipink}{HTML}{CF4B6A}

%% Class is based on the default book class and options will be passed
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{tudelft-report}[05-09-2024 v1.7.1 TU Delft Report Class]

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{book}}
\ProcessOptions\relax
\LoadClass[10pt,oneside]{book}

%% Main packages in the document --- Some are imported later in the class file
\RequirePackage{mathtools}  % Mathematical tools to use with amsmath
\RequirePackage{amssymb}    % Extended symbol collection
\RequirePackage{siunitx}    % Comprehensive (SI) units package

\RequirePackage{tabularx}   % Tabulars with adjustable-width columns
\RequirePackage{booktabs}   % Publication quality tables
\RequirePackage{longtable}  % Allow tables to flow over page boundaries
\RequirePackage{multirow}   % Create tabular cells spanning multiple rows

\usepackage{eso-pic}
\usepackage{graphicx}

\RequirePackage{float}      % Improved interface for floating objects
\RequirePackage[labelfont=bf,justification=centering,footnotesize]{caption} % Captions
\RequirePackage{subcaption} % Support for sub-captions
\RequirePackage{pdfpages}   % Include PDF documents

\RequirePackage[pdfusetitle,hidelinks]{hyperref} % Extensive support for hypertext
\RequirePackage[noabbrev]{cleveref} % Intelligent cross-referencing
\RequirePackage{xcolor}     % Driver-independent color extensions
\RequirePackage{tikz}       % Create PostScript and PDF graphics
\RequirePackage{xspace}     % Define commands that appear not to eat spaces
\RequirePackage{microtype}  % Refinements towards typographical perfection

\RequirePackage{geometry}   % Customize document dimensions
\RequirePackage{titlesec}   % Select alternative section titles
\RequirePackage{titletoc}   % Alternative headings for toc
\RequirePackage{fancyhdr}   % Control of page headers and footers
\RequirePackage{enumitem}   % Control layout of itemize, enumerate, description
\RequirePackage{etoolbox}   % Toolbox of programming facilities
\RequirePackage{iftex}      % Adds if-else statements to support multiple compilers
\RequirePackage{datetime}   % Change format of \today

%% Establish commands for the subtitle, subject, affiliation, cover image and table of authors
\newcommand*{\subtitle}[1]{\def\@subtitle{#1}}
\newcommand*{\subject}[1]{\def\@subject{#1}}
\newcommand*{\affiliation}[1]{\def\@affiliation{#1}}
\newcommand*{\coverimage}[1]{\def\@coverimage{#1}}
\newcommand*{\covertable}[1]{\def\@covertable{#1}}

%% Scale the margins to be slightly smaller than default (.7)
\geometry{a4paper,hscale=0.75,vscale=0.8}

%% ----------------------------------------------------------------------
%%    Setting up the fonts
%% ----------------------------------------------------------------------

\ifPDFTeX
    %% With pdfLaTeX, use Paletino as the main font and Roboto Slab as title fonts
    \RequirePackage[T1]{fontenc}  % Select T1 font encoding
    \RequirePackage{newpxtext}    % Palatino-like font...
    \RequirePackage{newpxmath}    % ...with support for mathematics

    \newcommand{\titlestyle}{\fontfamily{RobotoSlab-TLF}\fontseries{light}\selectfont}
    \newcommand{\largetitlestyle}{\fontfamily{RobotoSlab-TLF}\fontseries{thin}\selectfont}
\else
    %% If XeLaTeX or LuaLaTeX is set as the compiler, the TU Delft house style fonts are used (see https://www.tudelft.nl/huisstijl/bouwstenen/typografie).
    \RequirePackage[no-math]{fontspec} % Advanced font selection

    %% Use Arial as the main font and Roboto Slab as title fonts
    \setmainfont{Arial}
    \setmathsf{Arial}
    \setmathtt{Arial}

    \newfontfamily\titlestyle{Roboto Slab Light}
    \newfontfamily\largetitlestyle{Roboto Slab Thin}
\fi

%% ----------------------------------------------------------------------
%%    Formatting the titles and table of contents
%% ----------------------------------------------------------------------

\titleformat{\chapter}[display]
    {\flushright\color{amsipink}}
    {\fontsize{96}{96}\selectfont\largetitlestyle\thechapter}
    {0pt}
    {\Huge\titlestyle}

\titleformat{\section}
    {\Large\titlestyle\bfseries\color{amsipink}}
    {\thesection.}
    {5pt}
    {}

\titleformat{\subsection}
    {\large\titlestyle\bfseries\color{amsipink}}
    {\thesubsection.}
    {5pt}
    {}

\titleformat{\subsubsection}
    {\titlestyle\bfseries\color{amsipink}}
    {\thesubsubsection.}
    {5pt}
    {}
\titlespacing*{\subsubsection}{0pt}{\bigskipamount}{0pt}
\titlespacing*{\chapter}{0pt}{-50pt}{20pt}




%% Reduce the vertical white space between chapters in the table of contents
\dottedcontents{chapter}[1.5em]{\vspace{0.5\baselineskip}\bfseries}{1.5em}{0pt}

%% ----------------------------------------------------------------------
%%    Formatting the header and footer
%% ----------------------------------------------------------------------

% ====== AMSI header/footer pleine largeur ======
\RequirePackage{eso-pic}
\RequirePackage{graphicx}

\newcommand{\AMSIBandeau}{%
  \AddToShipoutPictureBG{%

    % Bandeau footer (image)
    \AtPageLowerLeft{%
      \includegraphics[width=\paperwidth]{figures/footer.png}%
    }%

    % Numéro de page (à droite du bandeau)
    \AtPageLowerLeft{%
      \raisebox{10mm}{% ajuste la hauteur selon ton bandeau
        \hspace*{\paperwidth}%
        \makebox[-15mm][r]{\color{white}\bfseries\thepage}%
      }%
    }%
  }%
}


% Activer automatiquement le bandeau AMSI sur toutes les pages
\AtBeginDocument{\AMSIBandeau}

%% ----------------------------------------------------------------------
%%    Setting up listings
%% ----------------------------------------------------------------------

\RequirePackage{listings} % Typeset source code listings

\lstset{
  basicstyle=\ttfamily\footnotesize,  % Style of the font that is used for the code
  backgroundcolor=\color{gray!10},    % Background color
  keywordstyle=\color{red!75!black},  % Keyword style
  stringstyle=\color{green!40!black}, % String style
  commentstyle=\color{blue!30!black}, % Comment style
  numbers=left,                       % Add line numbers on the left side
  numbersep=5pt,                      % Decrease distance between line numbers and code
  numberstyle=\tiny,                  % Line number style
  breaklines=true,                    % Line break automatically
}
