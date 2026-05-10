% CCN Conference Document Class
% ==============================
%
% VERSION HISTORY:
%   Original : P.F. Patel-Schneider and other for IJCAI-89, AAAI-90, COGSCI-91
%   Modified : Ashwin Ram (ashwin@cc.gatech.edu)       04/01/1994
%   Modified : Johanna Moore (jmoore@cs.pitt.edu)      03/17/1995
%   Modified : David Noelle (noelle@ucsd.edu)          03/15/1996
%   Modified : Pat Langley (langley@cs.stanford.edu)   01/26/1997
%   Latex2e corrections by Ramin Charles Nakisa        01/28/1997
%   Modified : Tina Eliassi-Rad (eliassi@cs.wisc.edu)  01/31/1998
%   Modified : Trisha Yannuzzi (trisha@ircs.upenn.edu) 12/28/1999
%   Modified : Mary Ellen Foster (M.E.Foster@ed.ac.uk) 12/11/2000
%   Modified : Ken Forbus                              01/23/2004
%   Modified : Eli M. Silk (esilk@pitt.edu)            05/24/2005
%   Modified : Niels Taatgen (taatgen@cmu.edu)         10/24/2006
%   Modified : David Noelle (dnoelle@ucmerced.edu)     11/19/2014
%   Modified : Konrad Kording (koerding@gmail.com)     02/15/2017
%   Modified : Thomas Naselaris (tnaselar@gmail.com)   03/18/2022
%   Modified : Sneha Aenugu & Jasper van den Bosch     18/12/2024
%   Modified : Erin Grant                                   v2026.0

\NeedsTeXFormat{LaTeX2e}[2020/10/01]
\ProvidesClass{ccn}[v2026.0 CCN Conference Document Class]

%% ============================================================================
%% VERSION OPTIONS
%% ============================================================================

\newif\if@ccnpreprint
\newif\if@ccnsubmission
\newif\if@ccnproceedings
\newif\if@ccnea

\@ccnsubmissiontrue

\DeclareOption{preprint}{\@ccnpreprinttrue\@ccnsubmissionfalse\@ccnproceedingsfalse\@ccneafalse}
\DeclareOption{submission}{\@ccnpreprintfalse\@ccnsubmissiontrue\@ccnproceedingsfalse\@ccneafalse}
\DeclareOption{proceedings}{\@ccnpreprintfalse\@ccnsubmissionfalse\@ccnproceedingstrue\@ccneafalse}
\DeclareOption{extended-abstract}{\@ccnpreprintfalse\@ccnsubmissionfalse\@ccnproceedingsfalse\@ccneatrue}
\DeclareOption*{\ClassWarning{ccn}{Unknown option '\CurrentOption'}}
\ProcessOptions\relax

% Load base class
\LoadClass[10pt,letterpaper]{article}

%% ============================================================================
%% CONFERENCE CONFIGURATION
%% ============================================================================

% TODO: Increment this yearly.
\newcommand{\@ccnyear}{2026}
\newcommand{\@ccnedition}{9th}
\newcommand{\@ccnlocation}{New York, NY, USA}

\let\@ccndoi\@empty
\newcommand{\@ccnlicense}{CC BY 4.0}
\newcommand{\@ccnlicenseurl}{https://creativecommons.org/licenses/by/4.0/}

\newcommand{\ccnyear}[1]{\renewcommand{\@ccnyear}{#1}}
\newcommand{\ccnedition}[1]{\renewcommand{\@ccnedition}{#1}}
\newcommand{\ccnlocation}[1]{\renewcommand{\@ccnlocation}{#1}}

\newcommand{\ccndoi}[1]{\def\@ccndoi{#1}}
% License lookup using csname.
\newcommand{\ccnlicense}[1]{%
  \renewcommand{\@ccnlicense}{#1}%
  \@ifundefined{@ccnlicenseurl@#1}{%
    \ClassError{ccn}{Unknown license '#1'}{Valid licenses: CC BY 4.0, CC BY-SA 4.0, CC BY-NC 4.0, CC BY-ND 4.0, CC BY-NC-SA 4.0, CC BY-NC-ND 4.0}%
  }{%
    \edef\@ccnlicenseurl{\csname @ccnlicenseurl@#1\endcsname}%
  }%
}
\@namedef{@ccnlicenseurl@CC BY 4.0}{https://creativecommons.org/licenses/by/4.0/}
\@namedef{@ccnlicenseurl@CC BY-SA 4.0}{https://creativecommons.org/licenses/by-sa/4.0/}
\@namedef{@ccnlicenseurl@CC BY-NC 4.0}{https://creativecommons.org/licenses/by-nc/4.0/}
\@namedef{@ccnlicenseurl@CC BY-ND 4.0}{https://creativecommons.org/licenses/by-nd/4.0/}
\@namedef{@ccnlicenseurl@CC BY-NC-SA 4.0}{https://creativecommons.org/licenses/by-nc-sa/4.0/}
\@namedef{@ccnlicenseurl@CC BY-NC-ND 4.0}{https://creativecommons.org/licenses/by-nc-nd/4.0/}

% Require DOI for Proceedings.
\AtBeginDocument{%
  \if@ccnproceedings
    \ifx\@ccndoi\@empty
      \ClassError{ccn}{DOI required for Proceedings}{Use \string\ccndoi\string{...\string} in your preamble.}%
    \fi
  \fi
}

%% ============================================================================
%% FONTS
%% ============================================================================

\RequirePackage{cmap}
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}
\RequirePackage{tgheros}
\renewcommand{\familydefault}{\sfdefault}
\RequirePackage{amsmath,amssymb}
\RequirePackage[helvet]{sfmath}

%% ============================================================================
%% GRAPHICS AND COLORS
%% ============================================================================

\RequirePackage{xcolor}
\RequirePackage{tikz}

\definecolor{ccnBlue}{RGB}{178,198,222}
\definecolor{ccnPink}{RGB}{239,198,191}
\definecolor{ccnLavender}{RGB}{246,230,239}
\definecolor{ccnGreen}{RGB}{173,216,192}
\definecolor{ccnCyan}{RGB}{206,238,239}
\definecolor{ccnBeige}{RGB}{245,238,224}
\definecolor{ccnWhite}{RGB}{250,248,248}

\definecolor{ccnLinks}{RGB}{160,178,200}  % darker CCN blue
\definecolor{ccnfootertext}{RGB}{130,140,155}  % gray

% CCN Logo
\newcommand{\ccnlogo}[1][1]{%
  \begin{tikzpicture}[scale=#1]
    \def\radius{0.25}\def\sep{0.145}
    \coordinate (blue) at (150:\sep);
    \coordinate (pink) at (30:\sep);
    \coordinate (green) at (270:\sep);
    \fill[ccnBlue] (blue) circle (\radius);
    \fill[ccnPink] (pink) circle (\radius);
    \fill[ccnGreen] (green) circle (\radius);
    \begin{scope}\clip (blue) circle (\radius);\fill[ccnLavender] (pink) circle (\radius);\end{scope}
    \begin{scope}\clip (blue) circle (\radius);\fill[ccnCyan] (green) circle (\radius);\end{scope}
    \begin{scope}\clip (pink) circle (\radius);\fill[ccnBeige] (green) circle (\radius);\end{scope}
    \begin{scope}\clip (blue) circle (\radius);\clip (pink) circle (\radius);\fill[ccnWhite] (green) circle (\radius);\end{scope}
  \end{tikzpicture}%
}

%% ============================================================================
%% BIBLIOGRAPHY (BibLaTeX APA 7)
%% ============================================================================

\RequirePackage{xurl}  % better URL line breaking
\RequirePackage[style=apa,backend=biber,natbib=true,uniquename=false,uniquelist=false]{biblatex}
\DeclareFieldFormat{doi}{\url{https://doi.org/#1}}
\setlength{\bibhang}{0.25in}
\apptocmd{\bibsetup}{\emergencystretch=1em}{}{}  % prevent overflow in narrow columns

%% ============================================================================
%% PAGE LAYOUT
%% ============================================================================

\newlength{\ccn@sidemargin}     \setlength{\ccn@sidemargin}{-0.25in}
\newlength{\ccn@textwidth}      \setlength{\ccn@textwidth}{7in}
\newlength{\ccn@textheight}     \setlength{\ccn@textheight}{8.75in}
\newlength{\ccn@columnsep}      \setlength{\ccn@columnsep}{0.25in}
\newlength{\ccn@footskip}       \setlength{\ccn@footskip}{36pt}

\setlength\oddsidemargin{\ccn@sidemargin}
\setlength\evensidemargin{\ccn@sidemargin}
\setlength\textwidth{\ccn@textwidth}
\setlength\textheight{\ccn@textheight}
\setlength\columnsep{\ccn@columnsep}
\setlength\headheight{0pt}
\setlength\headsep{0pt}
\setlength\footskip{\ccn@footskip}
\setlength\topmargin{0in}

% Allow flexible line breaking; for two-column layout.
\tolerance=1000
\emergencystretch=1em
\hbadness=1000

\twocolumn
\flushbottom

%% ============================================================================
%% LINE NUMBERS (submission mode only)
%% ============================================================================

\RequirePackage{lineno}
\RequirePackage{atbegshi}

\if@ccnsubmission
  \setlength{\linenumbersep}{6pt}
  \AtBeginDocument{\linenumbers}
\fi

%% ============================================================================
%% PDF METADATA
%% ============================================================================

\RequirePackage{hyperref}

\hypersetup{colorlinks=true,linkcolor=black,urlcolor=ccnLinks,citecolor=black}
\if@ccnsubmission\hypersetup{pdfauthor={Anonymous}}\fi

%% ============================================================================
%% PAGE STYLE AND FOOTER
%% ============================================================================

\RequirePackage{fancyhdr}

\def\@ccndoilink{\ifx\@ccndoi\@empty\else\href{https://doi.org/\@ccndoi}{\textcolor{ccnLinks}{\texttt{doi:\@ccndoi}}} \fi}
\def\@ccncopyright{Copyright \@ccnyear\ by the author(s). Licensed under \href{\@ccnlicenseurl}{\@ccnlicense}.}
\def\@ccnfootertext{%
  \if@ccnsubmission In submission to the \textit{\@ccnedition\ Conference on Cognitive Computational Neuroscience} (CCN \@ccnyear).\fi
  \if@ccnproceedings In \textit{Proceedings of the \@ccnedition\ Conference on Cognitive Computational Neuroscience}, \@ccnlocation, \@ccnyear. \@ccndoilink\@ccncopyright\fi
  \if@ccnea Extended abstract presented at the \textit{\@ccnedition\ Conference on Cognitive Computational Neuroscience}, \@ccnlocation, \@ccnyear. \@ccncopyright\fi
}

% Official footer with logo; for accepted work.
\def\@ccnofficialfooter{%
  \raisebox{-0.2ex}{\ccnlogo}\hspace{0.8em}%
  \begin{minipage}[b]{\dimexpr\textwidth-0.5in\relax}%
    \setlength{\parindent}{0pt}\normalsize\textcolor{ccnfootertext}{\@ccnfootertext}%
  \end{minipage}%
}

\fancypagestyle{ccnfirstpage}{%
  \fancyhf{}%
  \renewcommand{\headrulewidth}{0pt}%
  \renewcommand{\footrulewidth}{0pt}%
  \if@ccnproceedings
    \fancyfoot[L]{\@ccnofficialfooter}%
  \fi
  \if@ccnea
    \fancyfoot[L]{\@ccnofficialfooter}%
  \fi
  \if@ccnsubmission
    \fancyfoot[L]{\begin{minipage}[b]{\textwidth}\setlength{\parindent}{0pt}\normalsize\textcolor{ccnfootertext}{\@ccnfootertext}\end{minipage}}%
  \fi
}

\fancypagestyle{ccnplain}{\fancyhf{}\renewcommand{\headrulewidth}{0pt}\renewcommand{\footrulewidth}{0pt}\fancyfoot[C]{\footnotesize\thepage}}

\pagestyle{ccnplain}

\if@ccnpreprint
  \thispagestyle{empty}
  \pagestyle{empty}
\else
  \AtBeginDocument{\thispagestyle{ccnfirstpage}}
  \AtBeginShipoutNext{\global\setlength{\textheight}{9.25in}\global\setlength{\footskip}{30pt}}
\fi

%% ============================================================================
%% TITLE AND AUTHOR
%% ============================================================================

\newcounter{ccn@affcount}
\newcommand{\@ccnaffiliations}{}
\newcommand{\affmark}[1]{\textsuperscript{\scriptsize #1}}
\newcommand{\affiliation}[2]{%
  \g@addto@macro\@ccnaffiliations{\par\affmark{#1}\,#2}%
}
\newcommand{\email}[1]{\texttt{#1}}
\newcommand{\emails}[1]{\gdef\@ccnemails{#1}}
\newcommand{\@ccnemails}{}

\def\maketitle{\par
  \begingroup
  \twocolumn[\@maketitle] \@thanks
  \endgroup
  \let\maketitle\relax \let\@maketitle\relax
  \gdef\@thanks{}\gdef\@author{}\gdef\@title{}\let\thanks\relax
  \gdef\@ccnaffiliations{}\gdef\@ccnemails{}}

\def\@maketitle{%
  \linewidth\hsize
  \centering
  {\LARGE\bfseries \@title \par}
  \vskip 0.75em
  \if@ccnsubmission
    {\large Anonymous Author(s)\par}
  \else
    {\def\and{\unskip\enspace{\rmfamily and}\enspace}%
      \def\And{\end{tabular}\hss \egroup \hskip 0.5in plus 2fil
        \hbox to 0pt\bgroup\hss \begin{tabular}[t]{c}\normalsize\bfseries}%
          \def\AND{\end{tabular}\hss\egroup \hfil\hfil\egroup
        \vskip 0.5em
        \hbox to \linewidth\bgroup \hfil\hfil
        \hbox to 0pt\bgroup\hss \begin{tabular}[t]{c}\normalsize\bfseries}%
      \hbox to \linewidth\bgroup \hfil\hfil
      \hbox to 0pt\bgroup\hss \begin{tabular}[t]{c}\normalsize\bfseries\@author
      \end{tabular}\hss\egroup
      \hfil\hfil\egroup}%
    % Render affiliations if defined (compact style)
    \ifx\@ccnaffiliations\empty\else
      \vskip 0.5em
        {\small\@ccnaffiliations\par}%
    \fi
    % Render emails if defined
    \ifx\@ccnemails\empty\else
      \vskip 0.25em
        {\small\texttt{\@ccnemails}\par}%
    \fi
  \fi
  \vskip 1.5em
}

%% ============================================================================
%% FOOTNOTES
%% ============================================================================

\footnotesep 6.65pt
\skip\footins 9pt plus 4pt minus 2pt
\def\footnoterule{\kern-3pt \hrule width 5pc \kern 2.6pt}
\setcounter{footnote}{0}

%% ============================================================================
%% ABSTRACT
%% ============================================================================

\renewenvironment{abstract}
{{\centering\bfseries Abstract\par}\begin{quote}\small}
    {\par\end{quote}}

%% ============================================================================
%% SECTIONS
%% ============================================================================

\def\section{\@startsection{section}{1}{\z@}{-1.5ex plus -0.25ex minus -0.2ex}{3pt plus 2pt minus 1pt}{\Large\bfseries\centering}}
\def\subsection{\@startsection{subsection}{2}{\z@}{-1.5ex plus -0.25ex minus -0.2ex}{3pt plus 2pt minus 1pt}{\large\bfseries\raggedright}}
\def\subsubsection{\@startsection{subsubsection}{3}{\z@}{-6pt plus 2pt minus 1pt}{-1em}{\normalsize\bfseries}}
\setcounter{secnumdepth}{0}

\parindent 10pt

%% ============================================================================
%% LISTS
%% ============================================================================

\topsep 4pt plus 1pt minus 2pt
\partopsep 1pt plus 0.5pt minus 0.5pt
\itemsep 1pt plus 1pt minus 0.5pt
\parsep 1pt plus 1pt minus 0.5pt

\leftmargin 10pt
\leftmargini\leftmargin
\leftmarginii 10pt
\leftmarginiii 5pt
\leftmarginiv 5pt
\leftmarginv 5pt
\leftmarginvi 5pt
\labelwidth\leftmargini\advance\labelwidth-\labelsep \labelsep 5pt

\def\@listi{\leftmargin\leftmargini}
\def\@listii{\leftmargin\leftmarginii
  \labelwidth\leftmarginii\advance\labelwidth-\labelsep
  \topsep 2pt plus 1pt minus 0.5pt
  \parsep 1pt plus 0.5pt minus 0.5pt
  \itemsep \parsep}
\def\@listiii{\leftmargin\leftmarginiii
  \labelwidth\leftmarginiii\advance\labelwidth-\labelsep
  \topsep 1pt plus 0.5pt minus 0.5pt
  \parsep \z@ \partopsep 0.5pt plus 0pt minus 0.5pt
  \itemsep \topsep}
\def\@listiv{\leftmargin\leftmarginiv
  \labelwidth\leftmarginiv\advance\labelwidth-\labelsep}
\def\@listv{\leftmargin\leftmarginv
  \labelwidth\leftmarginv\advance\labelwidth-\labelsep}
\def\@listvi{\leftmargin\leftmarginvi
  \labelwidth\leftmarginvi\advance\labelwidth-\labelsep}

%% ============================================================================
%% DISPLAY MATH
%% ============================================================================

\abovedisplayskip 7pt plus2pt minus5pt
\belowdisplayskip \abovedisplayskip
\abovedisplayshortskip 0pt plus3pt
\belowdisplayshortskip 4pt plus3pt minus3pt

\endinput
