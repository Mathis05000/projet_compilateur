#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void getInstructions(char ***tab, int *nbInstructions)
{
    FILE *fichier = fopen("assembleur.txt", "r");
    if (fichier == NULL)
    {
        printf("Erreur lors de l'ouverture du fichier\n");
        exit(0);
    }

    int MAX_LINES = 1000;
    int MAX_LENGTH = 100;

    char *lines[MAX_LINES];
    char buffer[MAX_LENGTH];

    int i = 0;
    while (fgets(buffer, MAX_LENGTH, fichier) != NULL && i < MAX_LINES)
    {
        // Supprime le retour à la ligne s'il y en a un
        if (buffer[strlen(buffer) - 1] == '\n')
        {
            buffer[strlen(buffer) - 1] = '\0';
        }

        // Alloue de la mémoire pour la ligne
        lines[i] = malloc(strlen(buffer) + 1);
        if (lines[i] == NULL)
        {
            printf("Erreur d'allocation de mémoire\n");
            exit(0);
        }

        // Copie la ligne dans le tableau
        strcpy(lines[i], buffer);
        i++;
    }

    fclose(fichier);

    // Affiche le contenu du tableau
    /*printf("##### instructions ####\n");
    for (int j = 0; j < i; j++)
    {
        printf("%s\n", lines[j]);
    }
    printf("#####  ####\n");*/
    *nbInstructions = i;
    *tab = lines;
}

int split(char *str, const char *delim, char ***substrings)
{
    char *tmp[100];
    int i = 0;
    char *token = strtok(str, delim);

    while (token != NULL)
    {
        tmp[i] = malloc(sizeof(char) * 50);
        tmp[i] = token;
        i++;
        token = strtok(NULL, delim);
    }

    *substrings = tmp;
    return i;
}

/*int main()
{
    char **result ;
    char str[] = "6 25 40";
    char * delim = " ";
    split(str, delim, &result);
    for (int i = 0; i < 3; i++)
    {
        printf("%s\n", result[i]);
    }
}*/

void splitInstructions(char **tabIn, char ****tabOut, int nbInstructions)
{
    char ***rslt = malloc(sizeof(char **) * 1000);

    for (int i = 0; i < nbInstructions; i++)
    {
        split(tabIn[i], " ", &rslt[i]);
    }

    *tabOut = rslt;
}

int main()
{
    char **instructions;
    int nbInstruction;
    getInstructions(&instructions, &nbInstruction);

    int var[1000];

    for (int i = 0; i < nbInstruction; i++)
    {
        char **tmp;
        split(instructions[i], " ", &tmp);
        // ADD
        if (instructions[i][0] == '1')
        {
            var[atoi(tmp[1])] = var[atoi(tmp[2])] + var[atoi(tmp[3])];
        }

        // MUL
        if (instructions[i][0] == '2')
        {
            var[atoi(tmp[1])] = var[atoi(tmp[2])] * var[atoi(tmp[3])];
        }

        // SOU
        if (instructions[i][0] == '3')
        {
            var[atoi(tmp[1])] = var[atoi(tmp[2])] - var[atoi(tmp[3])];
        }

        // DIV
        if (instructions[i][0] == '4')
        {
            var[atoi(tmp[1])] = var[atoi(tmp[2])] / var[atoi(tmp[3])];
        }

        // COP
        if (instructions[i][0] == '5')
        {
            var[atoi(tmp[1])] = var[atoi(tmp[2])];
        }

        // AFC
        if (instructions[i][0] == '6')
        {
            var[atoi(tmp[1])] = atoi(tmp[2]);
        }

        // INF
        if (instructions[i][0] == '9')
        {
            if (var[atoi(tmp[2])] < var[atoi(tmp[2])])
            {
                var[atoi(tmp[1])] = 1;
            }
            else
            {
                var[atoi(tmp[1])] = 0;
            }
        }

        // SUP
        if (instructions[i][0] == 'A')
        {
            if (var[atoi(tmp[2])] > var[atoi(tmp[3])])
            {
                var[atoi(tmp[1])] = 1;
            }
            else
            {
                var[atoi(tmp[1])] = 0;
            }
        }

        // EQU
        if (instructions[i][0] == 'B')
        {
            if (var[atoi(tmp[2])] == var[atoi(tmp[3])])
            {
                var[atoi(tmp[1])] = 1;
            }
            else
            {
                var[atoi(tmp[1])] = 0;
            }
        }

        // PRI
        if (instructions[i][0] == 'C')
        {
            printf("%d\n", var[atoi(tmp[1])]);
        }

        // JMP
        if (instructions[i][0] == '7')
        {
            i = atoi(tmp[1]) - 1;
        }
        else
        {
            // JMF
            if (instructions[i][0] == '8')
            {
                if (var[atoi(tmp[1])] == 1)
                {
                    i = atoi(tmp[2]) - 1;
                }
            }
        }
    }
}