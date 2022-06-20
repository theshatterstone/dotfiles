import random
import time
#setting up pygame
import pygame 
from pygame.locals import *
pygame.font.init()
pygame.init()

#setting up display
screen_width = 800
screen_height = 400

screen = pygame.display.set_mode((screen_width, screen_height))
pygame.display.set_caption('The Caveman') #Game title goes here


game_icon = pygame.image.load('img/CavemanIcon.png') #Icon goes here
pygame.display.set_icon(game_icon)

bg_img = pygame.transform.scale(pygame.image.load('img/new-bg.jpg'), (screen_width, screen_height) )

FPS = 60
clock = pygame.time.Clock()

def start_menu():
    screen.blit(bg_img, (0,0))
def main_game():
    screen.blit(bg_img, (0,0))
def gamewin():
    screen.blit(bg_img, (0,0))
def gamelose():
    screen.blit(bg_img, (0,0))

run = True
while run:
    start_menu()
    clock.tick(FPS)
    for event in pygame.event.get():
        if event.type == pygame.QUIT: 
            run = False
    
    pygame.display.update()

pygame.quit()